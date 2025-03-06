class Api::V1::SessionsController < Api::V1::ApplicationController
  skip_before_action :authenticate_user, only: [:login]

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def logout
    render json: { message: "Logged out successfully" }, status: :ok
  end
  
end
