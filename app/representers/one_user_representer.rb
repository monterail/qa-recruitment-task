class OneUserRepresenter < Struct.new(:user)
  def basic
    {
      id: user.id,
      name: user.name,
      email: user.email,
      birthday_day: user.birthday_day,
      birthday_month: user.birthday_month,
      about: user.about,
      done: user.done,
      szama: user.szama,
      propositions:
        {
          chosen: user.propositions_as_celebrant.chosen.map { |proposition| PropositionRepresenter.new(proposition).basic },
          current: user.propositions_as_celebrant.current.map { |proposition| PropositionRepresenter.new(proposition).basic },
        },
        person_responsible: (user.person_responsible.attributes.slice("id", "name", "email") if user.person_responsible)
    }
  end
end
