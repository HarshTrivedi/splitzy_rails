Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {registrations: "users/registrations", sessions: "users/sessions", passwords: "users/passwords"}, skip: [:sessions, :registrations]

  get   'syllabify/:language_name'  => 'landings#syllabify'         , as: :syllabify
  post   'syllabify/:language_name'  => 'landings#syllabify'         , as: :syllabify_remote

  post   '/clear_skipped_words'  => 'landings#clear_skipped_words'         , as: :clear_skipped_words

  post   '/mark_word/:word_id'  => 'landings#mark_word'         , as: :mark_word

  devise_scope :user do
    get    "login"   => "users/sessions#new",         as: :new_user_session
    post   "login"   => "users/sessions#create",      as: :user_session
    delete "signout" => "users/sessions#destroy",     as: :destroy_user_session
    
    get    "signup"  => "users/registrations#new",    as: :new_user_registration
    post   "signup"  => "users/registrations#create", as: :user_registration
    put    "signup"  => "users/registrations#update", as: :update_user_registration
    get    "account" => "users/registrations#edit",   as: :edit_user_registration
  end

  root 'landings#index'
end
