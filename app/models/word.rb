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
    syllabified_words = Word.where.not(:syllabifications_count => 0)
    potentially_wrong_words = syllabified_words.select{ |word|  ( [word.syllabifications.first.value.strip ] + (word.suggestion || "").split("&").map(&:strip)  ).uniq.size != 1  } 
    potentially_wrong_word_ids = potentially_wrong_words.map(&:id)
    Word.where( :word_id => potentially_wrong_word_ids )
  }

  scope :unresolved_multi_syllabified , ->{  
      syllabified_words = Word.where.not(:syllabifications_count => 0)
      unresolved_words = syllabified_words.select{|word| word.syllabifications.map(&:value).map(&:strip).uniq.size != 1 }
      unresolved_word_ids = unresolved_words.map(&:id)
      Word.where( :word_id => unresolved_word_ids )
  }


  validates :language, :presence => true

end
