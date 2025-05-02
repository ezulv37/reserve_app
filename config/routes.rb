Rails.application.routes.draw do
  get 'reservations/index'
  get 'rooms/index'
  resources :homes

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  # アカウント詳細ページ
  get 'users/account', to: 'users#account', as: 'user_account'

  # プロフィール関連
  get 'users/profile', to: 'profiles#show', as: 'user_profile'
  get 'users/profile/edit', to: 'profiles#edit', as: 'edit_user_profile'
  patch 'users/profile', to: 'profiles#update' # 編集フォーム送信先

  # roomモデル--reservationモデル
  get 'rooms/own', to: 'own#show', as: 'room_own'
  resources :rooms do
    resources :reservations, only: [:new, :create, :edit, :update, :destroy]
    post 'reservations/confirm', to: 'reservations#confirm', as: 'reservation_confirm'
  end

  root "homes#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
