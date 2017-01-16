class ApplicationController < ActionController::Base
  include JsEnv
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { message: e.message }, status: :not_found
  end

  def after_sign_in_path_for(resource)
    root_path
  end
end
