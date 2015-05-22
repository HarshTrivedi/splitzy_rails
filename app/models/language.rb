class Language < ActiveRecord::Base
  has_many :words


  def choose_word( user = nil)
  	## To be much improved !!
  	all_words = self.words
  	words_left = all_words.select{|x| x.syllabifications.size == 0}
  	return words_left.first , (all_words.size - words_left.size ) , all_words.size
  end


end
