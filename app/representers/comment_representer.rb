CommentRepresenter = Struct.new(:comment) do
  def basic
    {
      id: comment.id,
      body: comment.body,
      owner: User.participating.find(comment.owner_id).attributes.slice("id", "name"),
      created_at: comment.created_at,
    }
  end
end
