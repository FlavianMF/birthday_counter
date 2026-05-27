module AuthenticationHelper
  def login_as(user)
    post login_path, params: { email: user.email, password: 'password123' }
  end

  def auth_headers(user)
    token = JwtEncoder.encode({ user_id: user.id, role: user.role })
    { 'Authorization' => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
end
