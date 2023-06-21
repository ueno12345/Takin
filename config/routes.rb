Rails.application.routes.draw do
  get '/top_page', to: 'top_page#index', as: 'top_page'
  resources :users
  resources :assignments
  resources :work_hours  

  get '/teaching_assistants/remove', to: 'teaching_assistants#remove', as: 'remove_teaching_assistants'
  delete '/teaching_assistants/remove', to: 'teaching_assistants#destroy'
  resources :teaching_assistants do
    collection {post :import}
  end

  get '/courses/remove', to: 'courses#remove', as: 'remove_courses'
  delete '/courses/remove', to: 'courses#destroy'
  resources :courses do
    resources :assignments
    collection {post :import}
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "top_page#index"
end
