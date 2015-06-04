class Word < ActiveRecord::Base
  belongs_to :language
  has_many :syllabifications


  scope :not_syllabified , ->{  Word.where(:syllabifications_count => 0) }
  scope :one_syllabified , ->{  Word.where(:syllabifications_count => 1) }
  scope :two_syllabified , ->{  Word.where(:syllabifications_count => 2) }
  scope :three_syllabified , ->{  Word.where(:syllabifications_count => 3) }
  scope :three_plus_syllabified , ->{  Word.where( "syllabifications_count > ?" , 3) }
  scope :syllabified ,         ->{  Word.where.not(:syllabifications_count =>  0) }  
  scope :marked ,         ->{  Word.where(:marked =>  true) }


  scope :potentially_wrong , ->{ 
    potentially_wrong_word_ids = []
    Word.where.not(:syllabifications_count => 0).where.not(:syllabifications_count => 1).find_in_batches do |word_group|
      word_group.each do |word|
        if ( ( [word.syllabifications.first.value.strip ] + (word.suggestion || "").split("&").map(&:strip)  ).uniq.size != 1 )
          potentially_wrong_word_ids << word.id
        end
      end
    end
    Word.where( :id => potentially_wrong_word_ids )
  }

  scope :unresolved_multi_syllabified , ->{  
    unresolved_word_ids = []
    Word.where.not(:syllabifications_count => 0).where.not(:syllabifications_count => 1).find_in_batches do |word_group|
      word_group.each do |word|
        if ( word.syllabifications.map(&:value).map(&:strip).uniq.size != 1  )
          unresolved_word_ids << word.id
        end
      end
    end
    Word.where( :id => unresolved_word_ids )
  }


  validates :language, :presence => true

end
