class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  include JsEnv
  before_action :authenticate_user!

  def current_user
    @current_user ||= User.find_by(sso_id: current_user_data['uid'])
  end
end
