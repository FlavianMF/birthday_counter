Rails.application.routes.draw do
  # API Routes
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
          post 'join', to: 'events#join'
          get 'messages', to: 'events#messages'
          post 'messages', to: 'events#create_message'
          get 'ranking', to: 'events#ranking'
        end

        # Games nested under events
        post 'games/geoguessr/play', to: 'games#geoguessr_play'
        post 'games/fact-or-fiction/play', to: 'games#fact_or_fiction_play'
        post 'games/timeline-reorder/play', to: 'games#timeline_reorder_play'
      end
    end
  end

  # WebSocket/Cable
  mount ActionCable.server => '/cable'

  # Health check
  get '/health', to: lambda { |env| [200, {}, ['OK']] }

  # Root redirect
  root to: redirect('/health')
end
