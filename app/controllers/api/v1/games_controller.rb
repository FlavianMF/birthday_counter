module API
  module V1
    class GamesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_event
      before_action :set_ranking

      # POST /api/v1/events/:event_id/games/geoguessr/play
      def geoguessr_play
        guess_lat = params[:guess][:lat]
        guess_lng = params[:guess][:lng]
        actual_lat = params[:actual_lat]
        actual_lng = params[:actual_lng]

        distance_km = haversine_distance(guess_lat, guess_lng, actual_lat, actual_lng)
        score = calculate_geoguessr_score(distance_km)
        coins = (score / 10.0).to_i

        # Create game session
        session = GameSession.create!(
          event: @event,
          user: @current_user,
          game_type: 'geoguessr',
          score: score,
          game_data: {
            guess: { lat: guess_lat, lng: guess_lng },
            actual: { lat: actual_lat, lng: actual_lng },
            distance_km: distance_km
          },
          completed_at: Time.current
        )

        # Update ranking
        @ranking.add_score(score)
        CoinTransaction.create!(
          user: @current_user,
          event: @event,
          amount: coins,
          transaction_type: 'earned',
          source: 'geoguessr',
          description: "Geoguessr: #{score} points"
        )

        # Broadcast ranking update
        BroadcastService.broadcast_ranking_update(@event)

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
        # This would typically involve AI to generate facts
        # For now, simplified version
        is_correct = params[:is_correct]
        base_score = 500

        if is_correct
          score = base_score
          @ranking.add_score(score)
          CoinTransaction.create!(
            user: @current_user,
            event: @event,
            amount: (score / 10.0).to_i,
            transaction_type: 'earned',
            source: 'fact_or_fiction',
            description: "Fact or Fiction: correct answer"
          )
        else
          score = 0
        end

        BroadcastService.broadcast_ranking_update(@event)

        render json: {
          score: score,
          coins_earned: is_correct ? (score / 10).to_i : 0,
          is_correct: is_correct,
          new_total_score: @ranking.total_score,
          rank_position: @ranking.rank_position
        }
      end

      # POST /api/v1/events/:event_id/games/timeline-reorder/play
      def timeline_reorder_play
        # Check if ordering is correct
        is_correct = params[:is_correct]
        base_score = 1000

        if is_correct
          score = base_score
          @ranking.add_score(score)
          CoinTransaction.create!(
            user: @current_user,
            event: @event,
            amount: (score / 10.0).to_i,
            transaction_type: 'earned',
            source: 'timeline_reorder',
            description: "Timeline Reorder: perfect match"
          )
        else
          score = 0
        end

        BroadcastService.broadcast_ranking_update(@event)

        render json: {
          score: score,
          coins_earned: is_correct ? (score / 10).to_i : 0,
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
