class Api::V1::SessionsController < Api::V1::ApplicationController
  skip_before_action :authenticate_user, only: [:login]

  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      # Generate refresh token
      refresh_token = SecureRandom.hex(32)
      user.update(refresh_token: refresh_token)
      render json: { access_token: token, refresh_token: refresh_token }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def logout
    # Remove refresh token on logout
    @current_user.update(refresh_token: nil) 
    render json: { message: "Logged out successfully" }, status: :ok
  end
  
end
