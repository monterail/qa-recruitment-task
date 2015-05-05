module Api
  class UsersController < ApplicationController

    def index
      render json: UsersRepresenter.new(User.sooners(current_user['sso_id'])).basic
    end

    def show
      user = User.find(params[:id])
      if user['sso_id'] != current_user['uid']
       render json: OneUserRepresenter.new(User.find(params[:id])).basic
      else
        head :unauthorized
      end
    end

    def update
      user = User.find(params[:id])
      user.update(user_params)

      render json: OneUserRepresenter.new(user).basic
    end

    def update_me
      current_user.update(user_params)

      render json: CurrentUserRepresenter.new(current_user).basic
    end

    def me
      render json: CurrentUserRepresenter.new(current_user).basic
    end

    private
      def user_params
        params.require(:user).permit(:birthday_day, :birthday_month, :szama, :about, :done)
      end
  end
end
