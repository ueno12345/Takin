Rails.application.routes.draw do
  get '/top_page', to: 'top_page#index', as: 'top_page'
  resources :users
  resources :assignments

  get '/teaching_assistants/index_destroy', to: 'teaching_assistants#index_destroy', as: 'index_destroy_teaching_assistants'
  delete '/teaching_assistants/index_destroy', to: 'teaching_assistants#destroy'
  resources :teaching_assistants do
    collection {post :import}
  end

  get '/courses/index_destroy', to: 'courses#index_destroy', as: 'index_destroy_courses'
  delete '/courses/index_destroy', to: 'courses#destroy'
  delete '/courses/:course_id/assignments/:assignment_id/work_hours/:id', to: 'assignments#destroy', as: 'destroy_course_assignments'
  resources :courses do
    resources :assignments
    collection {post :import}
  end
  
  resources :work_hours  
  #resources :courses do
  #  resources :work_hours  
  #end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "top_page#index"
end