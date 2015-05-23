module ApplicationHelper


	def number_of_skipped_words
		skipped_list = session[:skipped_list]
		return (( session[:skipped_list]  || "").split(",").uniq).count
	end

end
