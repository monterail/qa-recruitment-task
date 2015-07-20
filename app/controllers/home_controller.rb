class HomeController < ApplicationController
  before_action :authenticate

  def index
  end

  def authenticate
    FindOrCreateUser.new.call(current_user_data)
  end
end
