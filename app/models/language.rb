class Language < ActiveRecord::Base
  has_many :words


  def choose_word( user = nil , skipped_list = []) 
  	## To be much improved !!
  	skipped_list = skipped_list || ""
  	skipped_list = skipped_list.split(",")
  	all_words = self.words
  	words_left = all_words.select{|x| x.syllabifications.size == 0} - skipped_list.map{|x| Word.find_by_id(x)}
  	return words_left.first , (all_words.size - words_left.size ) , all_words.size
  end


end
