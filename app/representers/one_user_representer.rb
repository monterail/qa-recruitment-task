class OneUserRepresenter < Struct.new(:user)
  def basic
    {
      id: user.id,
      name: user.name,
      email: user.email,
      birthday_day: user.birthday_day,
      birthday_month: user.birthday_month,
      about: user.about,
      covered: covered?,
      szama: user.szama,
      propositions:
        {
          chosen: user.propositions_as_celebrant.chosen.map { |proposition| PropositionRepresenter.new(proposition).basic },
          current: user.propositions_as_celebrant.current.map { |proposition| PropositionRepresenter.new(proposition).basic },
        },
      person_responsible: (
        if user.birthdays_as_celebrant.find_by_year(user.next_birthday_year)
          user.birthdays_as_celebrant.find_by_year(user.next_birthday_year).person_responsible.attributes.slice("id", "name", "email")
        end
        ),
      profile_photo: "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}"
    }
  end

  private

    def covered?
      user.next_birthday.try(:covered)
    end
end
