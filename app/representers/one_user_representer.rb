require "representable/json"

class OneUserRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :name
  property :email
  property :birthday_day
  property :birthday_month
  property :about
  property :covered?, as: :covered, exec_context: :decorator
  property :szama
  property :person_responsible, exec_context: :decorator
  property :profile_photo, exec_context: :decorator
  nested :propositions do
    property :chosen, exec_context: :decorator
    property :current, exec_context: :decorator

    def current
      @represented.propositions_as_celebrant
        .current.map { |proposition| PropositionRepresenter.new(proposition).basic }
    end

    def chosen
      @represented.propositions_as_celebrant
        .chosen.map { |proposition| PropositionRepresenter.new(proposition).basic }
    end
  end

  def profile_photo
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(@represented.email)}"
  end

  def person_responsible
    next_birthday_as_celebrant =
      @represented.birthdays_as_celebrant.find_by_year(@represented.next_birthday_year)
    return unless next_birthday_as_celebrant.present?
    next_birthday_as_celebrant.person_responsible.attributes.slice("id", "name", "email")
  end

  def covered?
    @represented.next_birthday.try(:covered)
  end
end
