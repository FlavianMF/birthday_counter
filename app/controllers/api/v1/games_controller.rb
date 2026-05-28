module API
  module V1
    class GamesController < API::V1::ApplicationController
      before_action :authenticate_user!
      before_action :set_event
      before_action :set_ranking

      # GET /api/v1/events/:event_id/games/fact-or-fiction/new
      def fact_or_fiction_new
        bio = @event.host.profile_data['bio_storytelling'] || "Host loves parties!"
        data = AiModerationService.generate_fact_or_fiction(bio)
        
        render json: {
          event_id: @event.id,
          statements: (data[:facts] + [data[:fiction]]).shuffle
        }
      end

      # POST /api/v1/events/:event_id/games/geoguessr/play
      def geoguessr_play
        guess_lat = params[:guess][:lat].to_f
        guess_lng = params[:guess][:lng].to_f
        actual_lat = params[:actual_lat].to_f
        actual_lng = params[:actual_lng].to_f

        distance_km = haversine_distance(guess_lat, guess_lng, actual_lat, actual_lng)
        base_score = calculate_geoguessr_score(distance_km)

        # Update ranking and get final score/coins
        result = @ranking.add_score(base_score)
        score = result[:points]
        coins = result[:coins]

        # Create game session
        session = GameSession.create!(
          event: @event,
          user: @current_user,
          game_type: 'geoguessr',
          score: score,
          game_data: {
            guess: { lat: guess_lat, lng: guess_lng },
            actual: { lat: actual_lat, lng: actual_lng },
            distance_km: distance_km,
            multiplier: result[:multiplier]
          },
          completed_at: Time.current
        )

        CoinTransaction.create!(
          user: @current_user,
          event: @event,
          amount: coins,
          transaction_type: 'earned',
          source: 'geoguessr',
          description: "Geoguessr: #{score} points (Multiplier: #{result[:multiplier]}x)"
        )

        # Broadcast ranking update
        BroadcastService.broadcast_ranking_update(@event)
        BroadcastService.broadcast_user_stats(@current_user)

        render json: {
          score: score,
          coins_earned: coins,
          distance_km: distance_km.round(2),
          new_total_score: @ranking.total_score,
          rank_position: @ranking.rank_position
        }
      end

      # POST /api/v1/events/:event_id/games/fact-or-fiction/play
      def fact_or_fiction_play
        is_correct = params[:is_correct] == true || params[:is_correct] == "true"
        base_score = is_correct ? 500 : 0

        ActiveRecord::Base.transaction do
          result = @ranking.add_score(base_score)
          @score = result[:points]
          @coins = result[:coins]
          
          if is_correct && @coins > 0
            CoinTransaction.create!(
              user: @current_user,
              event: @event,
              amount: @coins,
              transaction_type: 'earned',
              source: 'fact_or_fiction',
              description: "Fact or Fiction: correct answer (Multiplier: #{result[:multiplier]}x)"
            )
          end

          GameSession.create!(
            event: @event,
            user: @current_user,
            game_type: 'fact_or_fiction',
            score: @score,
            game_data: { is_correct: is_correct, multiplier: result[:multiplier] },
            completed_at: Time.current
          )
        end

        BroadcastService.broadcast_ranking_update(@event)
        # add_score already broadcasts user stats
        # BroadcastService.broadcast_user_stats(@current_user)

        render json: {
          score: @score,
          coins_earned: @coins,
          is_correct: is_correct,
          new_total_score: @ranking.total_score,
          rank_position: @ranking.rank_position
        }
      end

      # POST /api/v1/events/:event_id/games/timeline-reorder/play
      def timeline_reorder_play
        is_correct = params[:is_correct] == true || params[:is_correct] == "true"
        base_score = is_correct ? 1000 : 0

        ActiveRecord::Base.transaction do
          result = @ranking.add_score(base_score)
          @score = result[:points]
          @coins = result[:coins]

          if is_correct && @coins > 0
            CoinTransaction.create!(
              user: @current_user,
              event: @event,
              amount: @coins,
              transaction_type: 'earned',
              source: 'timeline_reorder',
              description: "Timeline Reorder: perfect match (Multiplier: #{result[:multiplier]}x)"
            )
          end

          GameSession.create!(
            event: @event,
            user: @current_user,
            game_type: 'timeline_reorder',
            score: @score,
            game_data: { is_correct: is_correct, multiplier: result[:multiplier] },
            completed_at: Time.current
          )
        end

        BroadcastService.broadcast_ranking_update(@event)
        # add_score already broadcasts user stats
        # BroadcastService.broadcast_user_stats(@current_user)

        render json: {
          score: @score,
          coins_earned: @coins,
          is_correct: is_correct,
          new_total_score: @ranking.total_score,
          rank_position: @ranking.rank_position
        }
      end

      private

      def set_event
        @event = Event.find(params[:event_id])
      end

      def set_ranking
        @ranking = Ranking.find_or_create_by!(event: @event, user: @current_user) do |r|
          r.total_score = 0
          r.coins = 0
          r.streak_days = 0
        end
      end

      def haversine_distance(lat1, lon1, lat2, lon2)
        rad_per_deg = Math::PI / 180
        earth_radius = 6371 # km

        lat1_rad = lat1 * rad_per_deg
        lat2_rad = lat2 * rad_per_deg
        delta_lat = (lat2 - lat1) * rad_per_deg
        delta_lon = (lon2 - lon1) * rad_per_deg

        a = Math.sin(delta_lat / 2) ** 2 +
            Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(delta_lon / 2) ** 2
        c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

        earth_radius * c
      end

      def calculate_geoguessr_score(distance_km)
        # Score formula: 5000 * e^(-distance / 1000)
        max_score = 5000
        (max_score * Math.exp(-distance_km / 1000)).to_i.tap { |s| s > 0 ? s : 0 }
      end
    end
  end
end
