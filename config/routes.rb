Rails.application.routes.draw do
  # Frontend Routes (Web)
  root "pages#home"
  
  # Authentication
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "logout", to: "sessions#destroy"
  
  get "register", to: "registrations#new"
  post "register", to: "registrations#create"

  # Invitations
  get "invite/:token", to: "invitations#show", as: :invite
  post "invite/:token/claim", to: "invitations#claim", as: :claim_invitation
  
  # Resources
  resources :events do
    member do
      get :messages
      post :messages, to: "events#create_message"
      get :join
      post :join, to: "events#process_join"
    end
    resources :rankings, only: [:index]
    resources :games, only: [:index] do
      collection do
        get :fact_or_fiction
      end
    end
    collection do
      get :search
      post :search, to: "events#find_by_code"
    end
  end
  
  resources :rankings, only: [:index]
  resources :games, only: [:index, :show]
  # Singular resource for user profile (no ID needed, uses current_user)
resource :profile, only: [:show, :edit, :update]
  
  # API Routes (for external calls or mobile apps)
  namespace :api do
    namespace :v1 do
      # Authentication
      post 'auth/register', to: 'auth#register'
      post 'auth/login', to: 'auth#login'
      post 'auth/refresh', to: 'auth#refresh_token'
      get 'auth/me', to: 'auth#me'

      # Events
      resources :events do
        member do
          post 'join'
          get 'messages', to: 'events#messages'
          post 'messages', to: 'events#create_message'
          get 'ranking'
        end
      end

      # Games
      get 'events/:event_id/games/fact-or-fiction/new', to: 'games#fact_or_fiction_new'
      post 'events/:event_id/games/geoguessr/play', to: 'games#geoguessr_play'
      post 'events/:event_id/games/fact-or-fiction/play', to: 'games#fact_or_fiction_play'
      post 'events/:event_id/games/timeline-reorder/play', to: 'games#timeline_reorder_play'

      # Shop
      post 'events/:event_id/shop/buy/:item_id', to: 'shop#buy'
    end
  end

  # WebSocket/Cable
  mount ActionCable.server => '/cable'

  # Health check
  get '/health', to: lambda { |env| [200, {}, ['OK']] }
end
