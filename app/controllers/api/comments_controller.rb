module Api
  class CommentsController < ApplicationController

    before_action :restrict_wrong_owner, only: [:update, :destroy]

    def create
      proposition = Proposition.find(params[:proposition_id])
      new_comment = proposition.comments.create(comment_params)
      render json: CommentRepresenter.new(new_comment).basic
    end

    def update
      if comment.update(comment_params)
        render json: CommentRepresenter.new(comment).basic
      else
        render json: { errors: comment.errors.messages }, status: 422
      end
    end

    def destroy
      if comment.destroy!
        head :ok
      else
        render json: { errors: comment.errors.messages }, status: 422
      end
    end

  private
    def comment
      @comment ||= Comment.find(params[:id])
    end

    def restrict_wrong_owner
      head :unauthorized if current_user.id != comment.owner_id
    end

    def comment_params
      params.require(:comment).permit(:proposition_id, :body).merge(owner_id: current_user.id)
    end
  end
end
