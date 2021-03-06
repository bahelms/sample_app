SampleApp::Application.routes.draw do
  root to: 'static_pages#home'  # Must delete public/index.html also
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions, only: [:new, :create, :destroy]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
	get    '/signup',  to: 'users#new'
  get    '/signin',  to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'
  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
end
