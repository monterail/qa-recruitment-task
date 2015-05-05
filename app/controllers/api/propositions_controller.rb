module Api
  class PropositionsController < ApplicationController

    def create
      render json: PropositionRepresenter.new(Proposition.create(proposition_params)).basic
    end

    def update
      proposition = Proposition.find(params[:id])
      current_user = User.find_by(sso_id: current_user_data['uid'])
      if current_user['id'] == proposition.owner_id
        proposition.update(proposition_params)
        render json: PropositionRepresenter.new(proposition).basic
      else
        head :unauthorized
      end
    end

  private
    def proposition_params
      params.require(:proposition).permit(:jubilat_id, :description, :title, :value, :year_chosen_in).merge(owner_id: User.find_by(sso_id: current_user_data['uid']).id) #tu jest problem, nie przypisuje current usera do nowej propozycji
    end
  end
end
