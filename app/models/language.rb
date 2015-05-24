class Language < ActiveRecord::Base
  has_many :words


  def choose_word( user = nil , skipped_list = []) 
    skipped_list = skipped_list || ""
    skipped_list = skipped_list.split(",").map(&:to_i)    

    non_syllabified_word_ids = self.words.where(:syllabifications_count => 0).select(:id).map(&:id)
    word_ids_left = non_syllabified_word_ids - skipped_list   
    skipped_list.each{|x| non_syllabified_word_ids.delete(x) }
    words_left = Word.where( :id => word_ids_left ).order(:value).limit(10)
    non_syllabified_words_size = non_syllabified_word_ids.size
    
    all_words_size = Word.count
    return words_left.sample , ( all_words_size - non_syllabified_words_size ) , all_words_size

  end


end
