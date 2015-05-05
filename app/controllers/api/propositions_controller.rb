module Api
  class PropositionsController < ApplicationController

    def create
      render json: PropositionRepresenter.new(current_user.propositions_as_owner.create(proposition_params)).basic
    end

    def update
      proposition = Proposition.find(params[:id])
      if current_user['id'] == proposition.owner_id
        proposition.update(proposition_params)
        render json: PropositionRepresenter.new(proposition).basic
      else
        head :unauthorized
      end
    end

  private
    def proposition_params
      params.require(:proposition).permit(:jubilat_id, :description, :title, :value, :year_chosen_in)
    end
  end
end
