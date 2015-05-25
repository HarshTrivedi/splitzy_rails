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

  validates :language, :presence => true

end
