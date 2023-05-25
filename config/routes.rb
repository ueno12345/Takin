Rails.application.routes.draw do
  resources :users
  resources :work_hours
  resources :assignments
  resources :teaching_assistants do
    collection {post :import}
  end

  get '/courses/remove', to: 'courses#remove', as: 'remove_courses'
  resources :courses do
    collection {post :import}
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "assignments#index"
end
