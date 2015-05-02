module Api
  class CommentsController < ApplicationController

    def create
      proposition = Proposition.find(params[:proposition_id])
      render json: CommentRepresenter.new(proposition.comments.create(comment_params)).basic
    end

    def update
      comment = Comment.find(params[:id])
      current_user = User.find_by(sso_id: current_user_data['uid'])
      unless current_user['id'] != comment.owner_id
        comment.update!(comment_params)
        render json: CommentRepresenter.new(comment).basic
      else
        head :unauthorized
      end
    end

  private
    def comment_params
      params.require(:comment).permit(:proposition_id, :body).merge(owner_id: User.find_by(sso_id: current_user_data['uid']).id)
    end
  end
end
