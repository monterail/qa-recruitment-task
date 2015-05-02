class OneUserRepresenter < Struct.new(:user)
  def basic
    {
      id: user["id"],
      name: user["name"],
      email: user["email"],
      birthday_day: user["birthday_day"],
      birthday_month: user["birthday_month"],
      about: user["about"],
      done: user["done"],
      szama: user["szama"],
      propositions:
        {
          chosen: user.propositions.map { |proposition| proposition["year_chosen_in"] != nil ? PropositionRepresenter.new(proposition).basic : nil }.compact,
          current: user.propositions.map { |proposition| proposition["year_chosen_in"] == nil ? PropositionRepresenter.new(proposition).basic : nil }.compact,
        },
        person_responsible: (user.person_responsible.attributes.slice("id", "name", "email") if user.person_responsible)
    }
  end
end
