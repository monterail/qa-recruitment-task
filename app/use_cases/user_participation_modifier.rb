class UserParticipationModifier
  def call(emails, is_participating)
    users = User.where(email: emails)
    users.update_all(is_participating: is_participating)
    return if is_participating
    users.each do |user|
      user
        .birthdays_as_person_responsible.upcomming_birthdays
        .each do |birthday|
          update_birthday_responsibility(birthday)
        end
    end
  end

  private

  def update_birthday_responsibility(birthday)
    birthday.update_attribute(:person_responsible,
                              User.next_user_responsible(birthday.celebrant))
  end
end
