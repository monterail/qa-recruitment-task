module Api
  class UsersController < ApplicationController

    def index
      render json: User.sooners(current_user_data['uid'])
    end

    def update
      user = User.find_by(sso_id: current_user_data['uid'])
      user.update!(user_params)

      render json: user
    end

    def show
      render json: User.find_by(sso_id: current_user_data['uid'])
    end

    private
      def user_params
        params.require(:user).permit(:name, :email)
      end
  end
end
