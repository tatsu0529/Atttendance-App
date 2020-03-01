Rails.application.routes.draw do

  # トップページ
  root 'static_pages#top'
  
  # 新規作成
  get '/signup', to: 'users#new'
  
  # ログイン機能
  get     '/login', to: 'sessions#new'
  post    '/login', to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'
  
  resources :users do
    collection { post :import }
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attended_employees'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    resources :attendances, only: :update
  end
  resources :bases do
    patch 'update'
  end
end
