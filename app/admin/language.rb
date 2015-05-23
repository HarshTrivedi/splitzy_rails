ActiveAdmin.register Language do
    menu label: "Language" , :priority => 2
	permit_params :value

	config.filters = false

    action_item :only => [:show , :edit ] do
       link_to( "Words" , admin_language_words_path( language )  )
    end

	index do
	      column :value
	      column :words do |language|
	          link_to( "words" , admin_language_words_path( language )  )
	      end
	      actions
	end

end
