module API
  module V1
    class EventsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_event, only: [:show, :update, :destroy, :join, :messages, :ranking]

      # GET /api/v1/events
      def index
        events = Event.active.includes(:host).order(:target_date)
        render json: events.map { |e| event_json(e) }
      end

      # GET /api/v1/events/:id
      def show
        render json: event_json(@event)
      end

      # POST /api/v1/events
      def create
        @event = Event.new(event_params)
        @event.host_id = @current_user.id

        if @event.save
          # Create event participant record for host
          EventParticipant.create!(
            event: @event,
            user: @current_user,
            role: 'host',
            has_accepted: true
          )

          render json: event_json(@event), status: :created
        else
          render json: { error: 'bad_request', message: @event.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /api/v1/events/:id
      def update
        return render json: { error: 'forbidden', message: 'Only host can update event' }, status: :forbidden unless @event.host_id == @current_user.id

        if @event.update(event_params)
          render json: event_json(@event)
        else
          render json: { error: 'bad_request', message: @event.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/events/:id
      def destroy
        return render json: { error: 'forbidden', message: 'Only host can delete event' }, status: :forbidden unless @event.host_id == @current_user.id

        @event.destroy
        head :no_content
      end

      # POST /api/v1/events/:id/join
      def join
        access_code = params[:access_code]

        if access_code != @event.access_code
          return render json: { error: 'unauthorized', message: 'Invalid access code' }, status: :unauthorized
        end

        participant = EventParticipant.find_or_create_by!(
          event: @event,
          user: @current_user
        ) do |p|
          p.role = 'guest'
          p.has_accepted = true
        end

        render json: { message: 'Joined event successfully', participant_id: participant.id }
      end

      # GET /api/v1/events/:id/messages
      def messages
        messages = @event.messages.includes(:sender).order(created_at: :desc).limit(50)
        render json: messages.map { |m| message_json(m) }
      end

      # POST /api/v1/events/:id/messages
      def create_message
        @message = @event.messages.new(message_params)
        @message.sender_id = @current_user.id

        if @message.save
          BroadcastService.broadcast_message(@event, @message)
          render json: message_json(@message), status: :created
        else
          render json: { error: 'bad_request', message: @message.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      # GET /api/v1/events/:id/ranking
      def ranking
        rankings = @event.rankings.includes(:user).order(total_score: :desc).limit(10)
        current_user_ranking = @event.rankings.find_by(user_id: @current_user.id)

        render json: {
          top_10: rankings.map { |r| ranking_json(r) },
          current_user: current_user_ranking ? ranking_json(current_user_ranking) : nil
        }
      end

      private

      def set_event
        @event = Event.find(params[:id])
      end

      def event_params
        params.require(:event).permit(:name, :description, :target_date, :is_surprise, :sponsor_id)
      end

      def message_params
        params.permit(:content, :message_type, :media_url)
      end

      def event_json(event)
        {
          id: event.id,
          name: event.name,
          description: event.description,
          target_date: event.target_date,
          status: event.status,
          host: {
            id: event.host.id,
            name: event.host.name
          },
          access_code: event.access_code,
          config: event.config
        }
      end

      def message_json(message)
        {
          id: message.id,
          content: message.content,
          message_type: message.message_type,
          media_url: message.media_url,
          is_revealed: message.is_revealed,
          reveal_date: message.reveal_date,
          sender: message.sender ? {
            id: message.sender.id,
            name: message.sender.name
          } : { name: message.sender_name },
          created_at: message.created_at
        }
      end

      def ranking_json(ranking)
        {
          user: {
            id: ranking.user.id,
            name: ranking.user.name
          },
          total_score: ranking.total_score,
          coins: ranking.coins,
          rank_position: ranking.rank_position
        }
      end
    end
  end
end
