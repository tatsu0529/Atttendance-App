Rails.application.routes.draw do

  # トップページ
  root 'static_pages#top'
  
  # 新規作成
  get '/signup', to: 'users#new'
  get '/create_overtime', to: 'attendance#overtime'
  
  # ログイン機能
  get     '/login', to: 'sessions#new'
  post    '/login', to: 'sessions#create'
  delete  '/logout', to: 'sessions#destroy'
  
  resources :users do
    collection { post :import }
    member do
      get 'attended_employees'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/overtime'
    end
      resources :attendances, only: :update
    end
  
    resources :bases do 
      member do
        get 'edit_basis_info'
      end 
    end
  end 