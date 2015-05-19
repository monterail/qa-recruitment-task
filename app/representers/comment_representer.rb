class CommentRepresenter < Struct.new(:comment)
  def basic
    {
      id: comment.id,
      body: comment.body,
      owner: User.find(comment.owner_id).attributes.slice("id", "name"),
      created_at: comment.created_at
    }
  end
end
