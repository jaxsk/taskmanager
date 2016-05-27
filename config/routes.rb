Rails.application.routes.draw do
  root 'tasks#index'

  devise_for :users

  resources :tasks do
    member do
      post :share
      put  :done
    end
  end

  get 'refresh_activities' => 'tasks#refresh_activities'
end
