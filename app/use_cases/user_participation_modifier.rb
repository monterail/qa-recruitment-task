class UserParticipationModifier
  # Update
  #
  # emails <Array<String> = List of emails of the use that want to update their
  # participation status
  #
  # participate <Boolean> = Indicated if the person wants or not to participate
  # in the game
  def call(emails, participate)
    users = User.where(email: emails)
    users.update_all(participate: participate)
    return if participate
    users.each do |user|
      user
        .birthdays_as_person_responsible.upcomming_birthdays
        .each do |birthday|
          update_birthday_responsibility(birthday)
        end
    end
  end

  private

  # Updates the responsibility of upcomming birthdays
  #
  # birthdays <Birthday::ActiveRecord_AssociationRelation> =
  #   Collection of birthdays
  def update_birthday_responsibility(birthday)
    birthday.update_attribute(:person_responsible,
                              User.next_user_responsible(birthday.celebrant))
  end
end
