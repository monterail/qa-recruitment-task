module Api
  class CommentsController < ApplicationController

    before_action :restrict_wrong_owner, only: [:update]

    def create
      proposition = Proposition.find(params[:proposition_id])
      new_comment = proposition.comments.create(comment_params)
      render json: CommentRepresenter.new(new_comment).basic
    end

    def update
      comment = Comment.find(params[:id])
      if comment.update(comment_params)
        render json: CommentRepresenter.new(comment).basic
      else
        render json: { errors: comment.errors.messages }, status: 422
      end
    end

  private
    def restrict_wrong_owner
      comment = Comment.find(params[:id])
      head :unauthorized if current_user.id != comment.owner_id
    end

    def comment_params
      params.require(:comment).permit(:proposition_id, :body).merge(owner_id: User.find_by(sso_id: current_user_data['uid']).id)
    end
  end
end
