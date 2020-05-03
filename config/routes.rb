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
      get 'edit_admin'
      patch 'update_admin'
      get 'attended_employees'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/overtime'
      patch 'attendances/request_overtime'
      get 'attendances/overtime_confirmation'
      patch 'attendances/reply_overtime'
      patch 'attendances/request_one_month'
      get 'attendances/attendance_confirmation'
      patch 'attendances/reply_attendance'
      get 'attendances/attendance_change'
      patch 'attendances/reply_change'
      get 'attendances/confirm_log_change'
    end
      resources :attendances do
      end
    end
  
    resources :bases do 
      member do
        get 'edit_basis_info'
      end 
    end
  end 