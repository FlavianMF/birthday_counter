class JwtEncoder
  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, Rails.application.secret_key_base, 'HS256')
  end
end

class JwtDecoder
  def self.decode(token)
    JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' }).first
  rescue JWT::ExpiredSignature
    raise JWT::DecodeError, 'Token has expired'
  rescue JWT::DecodeError
    raise JWT::DecodeError, 'Invalid token'
  end
end
