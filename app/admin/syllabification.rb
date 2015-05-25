ActiveAdmin.register Syllabification do
	menu false

	belongs_to :user , :optional => true

	permit_params :value, :note, :word_id	
	config.filters = false

	controller do

	    def new
	      @syllabification = Syllabification.new
	      @syllabification.word_id = params[:syllabification_id]
	    end

	    def create
	      @syllabification = Syllabification.new( permitted_params[:syllabification] )
	      @word = Word.find_by_id(params[:word_id])
	      @word.syllabifications << @syllabification
	      create!
	    end

	    def edit
	      @syllabification = Syllabification.find_by_id(params[:id])
	      @syllabification.word_id = params[:word_id]
	    end

	    def update
	      @syllabification = Syllabification.find(params[:id])
		  @syllabification.update_attributes(permitted_params[:syllabification])
	      update!
	    end

	    def destroy
	      @syllabification = Syllabification.find_by_id(params[:id])
	      destroy! do |format|
	          format.html { redirect_to :back }
	      end
	    end
	    

	end 


  index do
  		column :user do |syllabification|
  			link_to( syllabification.user.email , admin_user_path(syllabification.user) )
  		end
        column :word do |syllabification|
  			syllabification.word.value
        end
        column :syllabification do |syllabification|
  			syllabification.value 
        end
        column :note
        actions
  end


  show do
      panel "Syllabification Details" do
        attributes_table_for syllabification do
            row("Tagger's Email") { link_to( syllabification.user.email , admin_user_path(syllabification.user) ) }
            row("Original Word")  { syllabification.word.value  }
            row("Syllabified Word")  { syllabification.value  }
        end
      end
  end


	form do |f|
	      f.semantic_errors *f.object.errors.keys
	      f.inputs  "Syllabification Details" do
	      	  if not f.object.id
		          # add word_id only if it is NEW record
		          f.input :word_id, :as => :hidden ,  input_html: { :value => f.object.word_id }
		      end
	          f.input :value
	          f.input :note
	      end
	      f.actions
	end
	
	csv do
	 	column :language do |syllabification|
	 		syllabification.word.language.value
	 	end
	 	column :tagger do |syllabification|
	 		syllabification.user.email
	 	end
	    column :word do |syllabification|
	   		syllabification.word.value
	    end
	    column :value
	    column :created_at
	    column :note
	end


end
