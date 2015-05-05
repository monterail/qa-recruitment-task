class CommentRepresenter < Struct.new(:comment)
  def basic
    {
      id: comment.id,
      body: comment.body,
      owner: User.find(comment.owner_id).attributes.slice("id", "name"),
      proposition_id: comment.proposition_id
    }
  end
end
