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
      get 'attended_employees'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
        resources :attendances do
          member do
            get 'overtime'
            get 'notice_from_superior'
            get 'notice_of_attendance_change'
            get 'notice_of_overtime'
          end
        end
    end
  end
  resources :bases do 
      member do
      get 'edit_basis_info'
    end 
  end
end