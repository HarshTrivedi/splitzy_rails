ActiveAdmin.register Word do
	menu false
	belongs_to :language , :optional => true
	permit_params :value , :suggestion , :iteration
	active_admin_import

	scope :not_syllabified , :show_count => false
	# scope :one_syllabified 
	# scope :two_syllabified 
	# scope :three_syllabified 
	# scope :three_plus_syllabified 
	scope :syllabified , :show_count => false
	scope :marked , :show_count => false
	scope :potentially_wrong , :show_count => false
	scope :unresolved_multi_syllabified , :show_count => false

	  controller do

		  def new
		    @word = Word.new
		    @word.language_id = params[:language_id]
		  end

		  def create
		    @word = Word.new( permitted_params[:word] )
		    @language = Language.find_by_id(params[:language_id])
		    @language.words << @word
		    create!
		  end

		  def edit
		    @word = Word.find_by_id(params[:id])
		    @word.language_id = params[:language_id]
		  end

		  def update
		    @word = Word.find(params[:id])
		    @word.update_attributes(permitted_params[:word])
		    update!
		  end

		  def destroy
		    @word = Word.find_by_id(params[:id])
		    destroy! do |format|
		        format.html { redirect_to :back }
		    end
		  end

	  end 

	  index pagination_total: false do
	        column :id
	        column :iteration
	        column :value
	        column :suggestion
	        column :syllabifications do |word|
	        	raw word.syllabifications.map{|syllabification|  
	        		link_to "#{syllabification.value} (#{syllabification.id})" , admin_syllabification_path(syllabification)
	        	}.join("<br>")	          	
	        end
	        column :report do |word|
	        	word.report_category
	        end
	        actions
	  end

	  show do

	      panel "Word Details" do
	        attributes_table_for word do
	            row("Original Word")  { word.value  }
	            row("Syllabifications submitted")  { word.syllabifications.count  }
	            row("Report Category")  { word.report_category  }
	        end
	      end

	      panel "Syllabifications " do
	          table_for word.syllabifications do
	          	  column "id" do |syllabification|
	          	  		syllabification.id
	          	  end
	              column "user" do |syllabification|
			  			link_to( syllabification.user.email , admin_user_path(syllabification.user) )
	              end

        		  column "syllabification" do |syllabification|
  						link_to( syllabification.value , admin_syllabification_path(syllabification) )	  					 
        		  end
        		  
        		  column "note" do |syllabification|
        		  	syllabification.note
        		  end

        		  column :marked
	          end
	      end


	  end



	  form do |f|
	      f.semantic_errors *f.object.errors.keys
	      f.inputs  "Word Details" do
	          f.input :language_id, :as => :hidden ,  input_html: { :value => f.object.language_id }
	          f.input :value
	          f.input :suggestion
	      end
	      f.actions
	  end

	  filter :value , :label => "Word"
	  filter :marked, :label => "Marked?"
	  filter :report_category, :label => "Report Category"
	  filter :iteration, :label => "Iteration"


	csv do
	 	column :language do |word|
	 		word.language.value
	 	end
	    column :word do |word|
	   		word.value
	    end
	    column :syllabification do |word|
	   		word.syllabifications.first.value rescue ""
	    end
	end




end
