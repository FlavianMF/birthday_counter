module API
  module V1
    class AuthController < API::V1::ApplicationController
      # POST /api/v1/auth/register
      def register
        user = User.new(user_params)
        
        if user.save
          token = JwtEncoder.encode({ user_id: user.id, role: user.role })
          render json: {
            access_token: token,
            user: {
              id: user.id,
              email: user.email,
              name: user.name,
              role: user.role
            }
          }, status: :created
        else
          render json: { error: 'bad_request', message: user.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end

      # POST /api/v1/auth/login
      def login
        user = User.find_by(email: params[:email])

        if user&.authenticate(params[:password])
          return render json: { error: 'forbidden', message: 'Account is inactive' }, status: :forbidden unless user.active

          token = JwtEncoder.encode({ user_id: user.id, role: user.role })
          render json: {
            access_token: token,
            refresh_token: JwtEncoder.encode({ user_id: user.id }, 7.days.from_now),
            user: {
              id: user.id,
              email: user.email,
              name: user.name,
              role: user.role
            }
          }
        else
          render json: { error: 'unauthorized', message: 'Invalid credentials' }, status: :unauthorized
        end
      end

      # GET /api/v1/auth/me
      def me
        authenticate_user!
        render json: {
          id: @current_user.id,
          email: @current_user.email,
          name: @current_user.name,
          role: @current_user.role,
          profile_data: @current_user.profile_data
        }
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :name, :role)
      end
    end
  end
end
