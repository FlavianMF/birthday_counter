module API
  module V1
    class ApplicationController < ActionController::API
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
      rescue_from ActionController::ParameterMissing, with: :parameter_missing

      private

      def record_not_found(exception)
        render json: { error: 'not_found', message: 'Resource not found' }, status: :not_found
      end

      def parameter_missing(exception)
        render json: { error: 'bad_request', message: "Missing required parameter: #{exception.param}" }, status: :bad_request
      end

      def authenticate_user!
        token = request.headers['Authorization']&.split(' ')&.last
        return render_unauthorized unless token

        begin
          payload = JwtDecoder.decode(token)
          @current_user = User.find(payload['user_id'])
          return render_unauthorized unless @current_user.active
        rescue ActiveRecord::RecordNotFound, JWT::DecodeError
          return render_unauthorized
        end
      end

      def render_unauthorized
        render json: { error: 'unauthorized', message: 'Invalid or expired token' }, status: :unauthorized
      end

      def require_role(*roles)
        authenticate_user!
        unless roles.map(&:to_s).include?(@current_user.role)
          render json: { error: 'forbidden', message: 'Insufficient permissions' }, status: :forbidden
        end
      end

      def require_admin
        require_role(:admin)
      end
    end
  end
end
