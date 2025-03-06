class Api::V1::ApplicationController < ApplicationController
  before_action :authenticate_user

  private

  def authenticate_user
    header = request.headers['Authorization']
    token = header.split(' ').last if header
    decoded = JsonWebToken.decode(token)
    if decoded
      @current_user = User.find(decoded[:user_id])
    else
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
  
end
