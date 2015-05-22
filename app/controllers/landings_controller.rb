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
    language_name = params[:language]
    @language = Language.find_by_value( language_name )
    @word , @completed , @total = @language.choose_word(current_user) 
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
