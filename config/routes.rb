Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  get 'member/:id', to: 'members#show', as: 'member'
  get 'edit_description', to: 'members#edit_description', as: 'edit_memeber_description'
  patch 'update_description', to: 'members#update_description', as: 'update_memeber_description'
  get 'edit_personal_details', to: 'members#edit_personal_details', as: 'edit_memeber_personal_details'
  patch 'update_personal_details', to: 'members#update_personal_details', as: 'update_memeber_personal_details'
  get 'member-connections/:id', to: 'members#connections', as: 'members_connections'

  resources :work_experiences
  resources :connections
end