module AuthenticationHelper
  def login_as(user)
    post login_path, params: { email: user.email, password: 'password123' }
  end
end

RSpec.configure do |config|
  config.include AuthenticationHelper, type: :request
end
