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
  scope :potentially_wrong , ->{ Word.where.not(:syllabifications_count => 0).select{ |word|  ( [word.syllabifications.first.value.strip ] + (word.suggestion || "").split("&").map(&:strip)  ).uniq.size != 1  } }

  scope :unresolved_multi_syllabified , ->{ Word.where.not(:syllabifications_count => 0).select{|word| word.syllabifications.map(&:value).map(&:strip).uniq.size != 1 } }


  validates :language, :presence => true

end
