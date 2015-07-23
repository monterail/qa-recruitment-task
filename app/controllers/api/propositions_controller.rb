module Api
  class PropositionsController < ApplicationController

    before_action :restrict_wrong_owner, only: [:update, :destroy]

    def create
      render json: PropositionRepresenter.new(current_user.propositions_as_owner.create(proposition_params)).basic
    end

    def update
      if proposition.update(proposition_params)
        render json: PropositionRepresenter.new(proposition).basic
      else
        render json: { errors: proposition.errors.messages }, status: 422
      end
    end

    def destroy
      if proposition.destroy!
        head :ok
      else
        render json: { errors: proposition.errors.messages }, status: 422
      end
    end

    def choose
      proposition.update_attributes(year_chosen_in: Time.now.year)
      render json: PropositionRepresenter.new(proposition).basic
    end

    def unchoose
      proposition.update_attributes(year_chosen_in: nil)
      render json: PropositionRepresenter.new(proposition).basic
    end

  private

    def proposition
      @proposition ||= Proposition.find(params[:id])
    end

    def restrict_wrong_owner
      head :unauthorized if current_user.id != proposition.owner_id
    end

    def proposition_params
      params.require(:proposition).permit(:celebrant_id, :description, :title, :value, :year_chosen_in)
    end
  end
end
