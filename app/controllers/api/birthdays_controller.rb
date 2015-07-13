module Api
  class BirthdaysController < ApplicationController

    before_action :restrict_celebrant

    def mark_as_done
      birthday = birthday_from_params
      if birthday.update_attributes(done: true)
        head :ok
      else
        render json: { errors: birthday.errors.messages }, status: 405
      end
    end

    def mark_as_undone
      birthday = birthday_from_params
      if birthday.update_attributes(done: false)
        head :ok
      else
        render json: { errors: birthday.errors.messages }, status: 405
      end
    end

    private
      def birthday_from_params
        birthday ||= Birthday.find_by(celebrant_id: params[:celebrant_id], year: User.find(params[:celebrant_id]).next_birthday_year)
      end

      def restrict_celebrant
        birthday = birthday_from_params
        head :unauthorized if current_user.id == birthday.celebrant_id
      end

      def birthday_params
        params.require(:birthday).permit(:celebrant_id, :done)
      end
  end
end
