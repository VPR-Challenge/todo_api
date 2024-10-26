class SessionsController < ApplicationController
  skip_before_action :authorize_request, only: [:create]

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = encode_token({ user_id: user.id })
      render json: { user: user, jwt: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    render json: { message: 'Logged out' }, status: :ok
  end
end
