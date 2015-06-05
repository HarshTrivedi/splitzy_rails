class Language < ActiveRecord::Base
  has_many :words


  def choose_word( user = nil , skipped_list = []) 
    skipped_list = skipped_list || ""
    skipped_list = skipped_list.split(",").map(&:to_i)    

    # non_syllabified_word_ids = self.words.where(:syllabifications_count => 0).select(:id).map(&:id)
    ## mocking up here
    non_syllabified_word_ids = self.words.where(:marked => true , :report_category => "confusing" ).select(:id).map(&:id)
    ##

    word_ids_left = non_syllabified_word_ids - skipped_list   
    skipped_list.each{|x| non_syllabified_word_ids.delete(x) }
    words_left = Word.where( :id => word_ids_left ).order(:value).limit(50)
    non_syllabified_words_size = non_syllabified_word_ids.size
    
    all_words_size = Word.count
    return words_left.sample , ( all_words_size - non_syllabified_words_size ) , all_words_size

  end



  def get_top_similars( test_word , n)
    words = self.words.where.not( :syllabifications_count => 0 ).select(:value).map(&:value).to_a    
    word_scores = words.map{|word| [ word , compare_upto_ngrams( word , test_word , 4)]  }.sort_by{|x| - x.last}.take(n)
    selected_words = word_scores.map(&:first)
    selected_words.delete(test_word)
    word_ids = Word.where(:value => selected_words ).select(:id).map(&:id).to_a
    Syllabification.where(:word_id => word_ids )#.uniq.select(:value)
  end



  private
  
  def ngram(word , n); word.chars.each_cons(n).to_a.map(&:join); end
  
  def compare_upto_ngrams(word1 , word2 , n)
    answer = 0
    (2..n).each{|i| answer += ( i * (( ngram(word1 , i) & ngram(word2 , i) ).size)) }
    answer
  end

end
