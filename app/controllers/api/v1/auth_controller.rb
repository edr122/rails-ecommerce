class Api::V1::AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:login]

  def login
    admin = AdminUser.find_by(email: params[:email])

    if admin&.authenticate(params[:password])
      token = JsonWebToken.encode({ admin_user_id: admin.id })
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Unauthorized or invalid credentials' }, status: :unauthorized
    end
  end
end
