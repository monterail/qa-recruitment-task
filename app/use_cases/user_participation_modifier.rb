class UserParticipationModifier
  def call(emails, participating)
    users = User.where(email: emails)
    users.update_all(participating: participating)
    return if participating
    users.each do |user|
      user
        .birthdays_as_person_responsible
        .upcoming_birthdays
        .where(covered: false)
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
