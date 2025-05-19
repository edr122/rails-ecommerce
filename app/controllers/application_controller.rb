class ApplicationController < ActionController::API
  before_action :authorize_request

  def authorize_request
    header = request.headers['Authorization']
    header = header.split.last if header
    begin
      decoded = JsonWebToken.decode(header)
      @current_admin = AdminUser.find(decoded[:admin_user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: 'Unauthorized or invalid token' }, status: :unauthorized
    end
  end
end
