class LandingsController < ApplicationController
  respond_to :html , :js
  layout :layout_by_resource
 
  def index

    if current_user
        language = Language.first
        redirect_to syllabify_path( language.value)
    else
        render(:template => "landings/index")
    end


  end


  def syllabify
    language_name = params[:language_name]
    @language = Language.find_by_value( language_name )

    submit_type = params[:submit_type]

    if submit_type == "save"

            word_id = params[:word_id]
            user_id = current_user.id
            syllabified_text = params[:syllabified_text]
            @user = User.find_by_id(user_id)
            @word = Word.find_by_id(word_id)
            @syllabification = Syllabification.new( :user_id => user_id , :value => syllabified_text , :word_id => word_id)
            @syllabification.save
            skipped_list = session[:skipped_list]
            @word , @completed , @total = @language.choose_word(current_user , skipped_list ) 

    elsif submit_type == "skip"

            word_id = params[:word_id]
            session[:skipped_list]  = (( session[:skipped_list]  || "").split(",").uniq << word_id ).join(",")
            skipped_list = session[:skipped_list]
            @word , @completed , @total = @language.choose_word(current_user , skipped_list ) 

    elsif submit_type == "refresh"

            word_id = params[:word_id]
            @word = Word.find_by_id(word_id)
            words_left = @language.words.select{|x| x.syllabifications.size == 0}
            all_words = @language.words
            @completed , @total = (all_words.size - words_left.size ) , all_words.size

    else
            @word , @completed , @total = @language.choose_word(current_user , skipped_list ) 
    end
      

  end




  protected

  def layout_by_resource
      if not current_user.nil?
          "logged_in"
      else
          "application"
      end
  end

end
