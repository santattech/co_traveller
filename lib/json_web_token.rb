class JsonWebToken
  ALGORITHM = 'HS256'

  def self.encode(payload)
    JWT.encode(payload.merge(exp: 1.year.from_now.to_i), Rails.application.secrets.secret_key_base, ALGORITHM)
  end

  def self.decode(token)
    HashWithIndifferentAccess.new(JWT.decode(token, Rails.application.secrets.secret_key_base)[0])
  rescue JWT::DecodeError => e
    return { errors: e.message }
  end
end
