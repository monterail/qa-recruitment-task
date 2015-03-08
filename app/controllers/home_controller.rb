class HomeController < ApplicationController
  before_action :authenticate

  def index
  end
  
  def authenticate
    User.auth!(current_user_data)
  end
end
