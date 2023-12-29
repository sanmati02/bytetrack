Bytetrack::Application.routes.draw do
  get 'main/home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  resources :jobs do
    collection do
      get 'filter', to: 'jobs#index'
    end
  end

  root :to => 'main#home'

  get 'stats'=>'jobs#stats'

  resources :company_titles, only: [:index]
  resources :job_titles, only: [:index]
end