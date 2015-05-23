module Api
  class VotesController < ApplicationController

    def vote
      proposition = Proposition.find(params[:id])
      if proposition.votes.find_by_user_id(current_user.id)
        head :forbidden
      else
        vote = proposition.votes.create user: current_user
        render json: vote
      end
    end

    def unvote
      vote = Vote.find(params[:vote_id])
      if vote.user_id == current_user.id
        vote.destroy

        head 200
      else
        head :unauthorized
      end
    end
  end
end
