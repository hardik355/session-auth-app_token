class Api::V1::TokensController < Api::V1::ApplicationController
  skip_before_action :authenticate_user, only: [:refresh_token]

  def refresh_token
    user = User.find_by(refresh_token: token)
    
    if user
      new_access_token = JsonWebToken.encode(user_id: user.id)
      render json: { access_token: new_access_token }, status: :ok
    else
      render json: { error: "Invalid token" }, status: :unauthorized
    end 
  end
  
  private
  
  def token
    request.headers['HTTP_REFRESH_TOKEN']
  end
  
end
