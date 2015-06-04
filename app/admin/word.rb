ActiveAdmin.register Word do
	menu false
	belongs_to :language , :optional => true
	permit_params :value , :suggestion , :iteration
	active_admin_import

	scope :not_syllabified 
	# scope :one_syllabified 
	# scope :two_syllabified 
	# scope :three_syllabified 
	# scope :three_plus_syllabified 
	scope :syllabified   
	scope :marked 
	scope :potentially_wrong
	scope :unresolved_multi_syllabified

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

	  index do
	        column :id
	        column :iteration
	        column :value
	        column :suggestion
	        column :syllabifications do |word|
	        	raw word.syllabifications.map(&:value).join("<br>")	          	
	        end
	        actions
	  end

	  show do

	      panel "Word Details" do
	        attributes_table_for word do
	            row("Original Word")  { word.value  }
	            row("Syllabifications submitted")  { word.syllabifications.count  }
	        end
	      end

	      panel "Syllabifications " do
	          table_for word.syllabifications do
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
end
