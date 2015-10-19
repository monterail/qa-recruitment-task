class NotifyBeforeBirthdays
  DAYS_BEFORE_NOTIFICATIONS = [5, 10, 15]

  def call
    User
      .ordered_by_soonest_birthday
      .where.not(birthday_month: nil, birthday_day: nil)
      .each do |celebrant|
        next unless DAYS_BEFORE_NOTIFICATIONS.include?(days_till_birthday(celebrant))
        next if birthday_exist_and_covered?(celebrant)

        User.where.not(id: celebrant.id).each do |user|
          if celebrant.next_birthday.person_responsible_id == user.id
            NotifyResponsiblePersonWorker.perform_async(user.id, celebrant.id)
          else
            NotifyAboutBirthdaysWorker.perform_async(user.id, celebrant.id)
          end
        end
      end
  end

  private

  def days_till_birthday(celebrant)
    (celebrant.next_birthday_date - Time.zone.today).to_i
  end

  def birthday_exist_and_covered?(celebrant)
    birthday = celebrant.next_birthday
    birthday && birthday.covered
  end
end
