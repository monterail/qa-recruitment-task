module Api
  class BirthdaysController < BaseController
    before_action :restrict_celebrant

    def mark_as_covered
      if birthday.update_attributes(covered: true)
        head :ok
      else
        render json: { errors: birthday.errors.messages }, status: 405
      end
    end

    def mark_as_uncovered
      if birthday.update_attributes(covered: false)
        head :ok
      else
        render json: { errors: birthday.errors.messages }, status: 405
      end
    end

    private

    def birthday
      @birthday ||= begin
        next_birthday_year = User.find(params[:celebrant_id]).next_birthday_year
        Birthday.find_by(celebrant_id: params[:celebrant_id], year: next_birthday_year)
      end
    end

    def restrict_celebrant
      head :unauthorized if current_user.id == params[:celebrant_id]
    end
  end
end
