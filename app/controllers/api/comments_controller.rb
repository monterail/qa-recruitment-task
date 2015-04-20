module Api
  class CommentsController < ApplicationController

    def index
      proposition = Proposition.find(params[:proposition_id])
      render json: proposition.comments
    end

    def create
      proposition = Proposition.find(params[:proposition_id])
      render json: proposition.comments.create(comment_params)
    end

    def update
      comment = Comment.find(params[:id])
      comment.update!(comment_params)

      render json: comment
    end

  private
    def comment_params
      params.require(:comment).permit(:proposition_id, :body).merge(owner_id: User.find_by(sso_id: current_user_data['uid']).id)
    end
  end
end
