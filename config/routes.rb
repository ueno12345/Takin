Rails.application.routes.draw do
  get '/top_page', to: 'top_page#index', as: 'top_page'
  resources :users
  resources :work_hours
  resources :assignments
  
  get '/teaching_assistants/remove', to: 'teaching_assistants#remove', as: 'remove_teaching_assistants'
  resources :teaching_assistants do
    collection {post :import}
  end

  get '/courses/remove', to: 'courses#remove', as: 'remove_courses'
  resources :courses do
    collection {post :import}
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "top_page#index"
end
