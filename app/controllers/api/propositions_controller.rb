module Api
  class PropositionsController < ApplicationController

    before_action :restrict_wrong_owner, only: [:update]

    def create
      render json: PropositionRepresenter.new(current_user.propositions_as_owner.create(proposition_params)).basic
    end

    def update
      proposition = Proposition.find(params[:id])
      if proposition.update(proposition_params)
        render json: PropositionRepresenter.new(proposition).basic
      else
        render json: { errors: proposition.errors.messages }, status: 422
      end
    end

  private
    def restrict_wrong_owner
      proposition = Proposition.find(params[:id])
      head :unauthorized if current_user.id != proposition.owner_id
    end

    def proposition_params
      params.require(:proposition).permit(:jubilat_id, :description, :title, :value, :year_chosen_in)
    end
  end
end
