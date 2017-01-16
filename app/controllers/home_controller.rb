class HomeController < ApplicationController
  #before_action :authenticate

  def index
  end

  def authenticate
    FindOrCreateUser.new(current_user_data).call
  end
end
