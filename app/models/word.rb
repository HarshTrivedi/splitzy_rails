class Word < ActiveRecord::Base
  belongs_to :language
  has_many :syllabifications


  scope :not_yet_syllabified , ->{  Word.where(:syllabifications_count => 0) }
  scope :syllabified ,         ->{  Word.where.not(:syllabifications_count =>  0) }

end
