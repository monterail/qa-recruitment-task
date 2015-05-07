module Api
  class UsersController < ApplicationController

    before_action :restrict_current_user, except: [:index, :update_me, :me]

    def index
      render json: UsersRepresenter.new(User.sooners(current_user['sso_id'])).basic
    end

    def show
      render json: OneUserRepresenter.new(User.find(params[:id])).basic
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
      def restrict_current_user
        head :unauthorized if current_user.id.to_s == params[:id]
      end

      def user_params
        params.require(:user).permit(:birthday_day, :birthday_month, :szama, :about, :done)
      end
  end
end
