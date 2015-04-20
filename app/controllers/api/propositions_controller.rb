module Api
  class PropositionsController < ApplicationController

    def index
      render json: Proposition.where(jubilat_id: params[:user_id]).order(updated_at: :asc)
    end

    def create
      render json: Proposition.create(proposition_params)
    end

    def update
      proposition = Proposition.find(params[:id])
      proposition.update(proposition_params)
      render json: proposition
    end

    def comments
      proposition = Proposition.find(params[:id])

      render json: proposition.comments
    end

  private
    def proposition_params
      params.require(:proposition).permit(:jubilat_id, :description, :title, :value, :chosen).merge(owner_id: User.find_by(sso_id: current_user_data['uid']).id)
    end
  end
end
