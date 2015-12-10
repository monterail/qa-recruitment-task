PropositionRepresenter = Struct.new(:proposition) do
  def basic
    {
      id: proposition.id,
      title: proposition.title,
      description: proposition.description,
      value: proposition.value,
      year_chosen_in: proposition.year_chosen_in,
      owner: User.participating.find(proposition.owner_id).attributes.slice("id", "name"),
      comments: proposition.comments.map { |comment| CommentRepresenter.new(comment).basic },
      rating: proposition.votes.count,
      votes: proposition.votes,
    }
  end
end
