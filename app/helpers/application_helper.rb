module ApplicationHelper


	def number_of_skipped_words
		skipped_list = session[:skipped_list]
		return (( session[:skipped_list]  || "").split(",").uniq).count
	end

	def recent_syllabifications
		current_user.syllabifications.order("created_at desc").take(10)
	end


end
