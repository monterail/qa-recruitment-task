class NotifyBeforeBirthdays
  DAYS_BEFORE_NOTIFICATIONS = [1, 5, 15, 30]

  def call
    User
      .ordered_by_soonest_birthday
      .where.not(birthday_month: nil, birthday_day: nil)
      .each do |user|
      if DAYS_BEFORE_NOTIFICATIONS.include? days_till_birthday(user)
        unless birthday_exist_and_covered? user
          NotifyAboutBirthdaysWorker.perform_async(user.id)
        end
      end
    end
  end

  private

  def days_till_birthday(user)
    (user.next_birthday_date - Date.today).to_i
  end

  def birthday_exist_and_covered?(user)
    birthday = user.next_birthday
    birthday && birthday.covered
  end
end
