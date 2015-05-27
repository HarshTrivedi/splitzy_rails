module ApplicationHelper


	def number_of_skipped_words
		skipped_list = session[:skipped_list]
		return (( session[:skipped_list]  || "").split(",").uniq).count
	end

	def set_recently_submitted_word(syllabification)
		session[:recent] ||= []
		word = syllabification.word
		session[:recent] << [ word.id , word.value , syllabification.value ]
	end

	def get_recently_submitted_words
		(session[:recent] || []).reverse
	end

end
