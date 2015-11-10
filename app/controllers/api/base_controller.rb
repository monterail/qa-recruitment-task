module Api
  class BaseController < ApplicationController
    include JsEnv
    before_action :authenticate_user!
    protect_from_forgery with: :null_session
  end
end
