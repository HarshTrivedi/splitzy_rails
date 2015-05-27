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
            session[:skipped_list]  = (( session[:skipped_list]  || "").split(",") << word_id ).uniq.join(",")
            skipped_list = session[:skipped_list]
            @word , @completed , @total = @language.choose_word(current_user , skipped_list ) 

    elsif submit_type == "refresh"

            word_id = params[:word_id]
            skipped_list = session[:skipped_list]
            @word , @completed , @total = @language.choose_word(current_user , skipped_list )                                   
            @word = Word.find_by_id(word_id)

    else
            skipped_list = session[:skipped_list]
            @word , @completed , @total = @language.choose_word(current_user , skipped_list ) 
    end
      

  end

  def clear_skipped_words
        session[:skipped_list] = ""
        render :js => "$('#session-pin').html(\"<span class='glyphicon glyphicon-pushpin' aria-hidden='true'> 0 </span>\");"
  end


  def mark_word
      word_id = params[:word_id]
      word = Word.find_by_id(word_id)
      if word
          word.marked = true
          word.save
          render :js => "alert('Successfully Marked!')"
      else
          render :js => "alert('Sorry, word not found!')"          
      end
  end

  def show_syllabification

      @syllabification = Syllabification.find_by_id( params[:syllabification_id]  )
      if @syllabification.nil?
          flash[:error] = "Sorry, No such syllabification exists."
          redirect_to "/"
      end


  end

  def alter_syllabification

    language_name = params[:language_name]
    @language = Language.find_by_value( language_name )
    syllabification = Syllabification.find_by_id( params[:syllabification_id] )

    if not syllabification.nil?

        if current_user == syllabification.user
              submit_type = params[:submit_type]
              if submit_type == "update"
                syllabified_text = params[:syllabified_text]
                syllabification.value = syllabified_text
                flash[:notice] = "Successfully updated syllabification : #{syllabification.value}"
                syllabification.save
              elsif submit_type == "destroy"
                syllabification.destroy
                flash[:notice] = "Successfully destroyed syllabification : #{syllabification.value}"
              end
              render :js => "window.location = '/'"
        else
            render :js => "alert('Sorry, request was not successfull.')"
        end
    else
        flash[:notice] = "This syllabification doesn't exist any more."
        render :js => "window.location = '/'"
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
