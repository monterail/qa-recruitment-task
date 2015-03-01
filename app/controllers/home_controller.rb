class HomeController < ApplicationController
  before_action :authenticate

  def index
  end
  
  def authenticate
    user=User.auth!(current_user_data)
  end
end
