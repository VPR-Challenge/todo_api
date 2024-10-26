module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request
  end

  private

  def encode_token(payload)
    payload[:exp] = 24.hours.from_now.to_i
    JWT.encode(payload, ENV['JWT_SECRET'], 'HS256')
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, ENV['JWT_SECRET'], true, { algorithm: 'HS256' })
      rescue JWT::DecodeError, JWT::ExpiredSignature
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @current_user ||= User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!current_user
  end

  def authorize_request
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end