class Language < ActiveRecord::Base
  has_many :words


  def choose_word( user = nil , skipped_list = []) 
    skipped_list = skipped_list || ""
    skipped_list = skipped_list.split(",").map(&:to_i)
    all_word_ids = self.words.where(:syllabifications_count => 0).select(:id).map(&:id)
    word_ids_left = all_word_ids - skipped_list   
    skipped_list.each{|x| all_word_ids.delete(x) }
    words_left = Word.where( :id => word_ids_left ).order(:value).limit(1)
    all_words_size = all_word_ids.size
    return words_left.first , ( all_words_size - words_left.size ) , all_words_size
  end


end
