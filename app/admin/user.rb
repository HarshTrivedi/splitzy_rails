ActiveAdmin.register User do
  menu label: "Users" , :priority => 2

  permit_params :email, :password, :password_confirmation, :role , :first_name , :last_name


  show do
      panel "User Details" do
        attributes_table_for user do
            row("Email")  { user.email  }
            row("Words Tagged") {  user.words.count  }
            row("Syllabiciations Made") {  link_to( user.syllabifications.count , admin_user_syllabifications_path(user) ) }
            row("SignIn Count") { user.sign_in_count }
        end
      end
  end



    index do

        column :email
        column :syllabifications_made do |user|
            link_to( user.syllabifications.count , admin_user_syllabifications_path(user) )
        end
        column :sign_in_count
        actions
    end
 
    form do |f|
        f.semantic_errors *f.object.errors.keys
        f.inputs "User Details" do
            if f.object.email.empty?
              f.input :email 
              f.input :password
              f.input :password_confirmation
            end
            f.input :role, as: :radio, collection: { :content_generator => "content_generator" , :content_moderator => "content_moderator", :college_generator => "college_generator" }
        end
        f.actions
    end

    action_item :only => [:show , :edit ] do
       link_to( "syllabifications" , admin_user_syllabifications_path( user )  )
    end


    filter :email , :label => "Email"

end