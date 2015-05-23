ActiveAdmin.register Word do
	menu false
	belongs_to :language , :optional => true
	permit_params :value , :suggestion 
	active_admin_import

	scope :not_yet_syllabified
	scope :syllabified


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
	        column :value
	        column :syllabifications do |word|
	          link_to( "syllabifications" , admin_word_path( word )  )
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
	              column "course" do |bucket|
	                course = bucket.course
	                link_to( course.name , admin_course_path( course ) ) 
	              end

        		  column "word" do |syllabification|
  					syllabification.word.value
        		  end

        		  column "syllabification" do |syllabification|
  					syllabification.value 
        		  end
        		  
        		  column "note" do |syllabification|
        		  	syllabification.note
        		  end
	          end
	      end


	  end



	  form do |f|
	      f.semantic_errors *f.object.errors.keys
	      f.inputs  "Word Details" do
	          f.input :language_id, :as => :hidden ,  input_html: { :value => f.object.year_id }
	          f.input :value
	          f.suggestion :value
	      end
	      f.actions
	  end

	  filter :value , :label => "Word"

end
