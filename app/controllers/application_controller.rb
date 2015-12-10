class ApplicationController < ActionController::Base
  include JsEnv
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.message }, status: :not_found
  end

  def current_user
    @current_user ||= User.participating.find_by(sso_id: current_user_data["uid"])
  end
end
