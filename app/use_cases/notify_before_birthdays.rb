class NotifyBeforeBirthdays
  DAYS_BEFORE_NOTIFICATIONS = [1, 5, 15, 30]

  def call
    User
      .ordered_by_soonest_birthday
      .where.not(birthday_month: nil, birthday_day: nil)
      .each do |user|
        if DAYS_BEFORE_NOTIFICATIONS.include? days_till_birthday(user)
          unless birthday_exist_and_done? user
            NotifyAboutBirthdaysWorker.perform_async(user.id)
          end
        end
    end
  end

  private
    def days_till_birthday(user)
      (user.next_birthday_date - Date.today).to_i
    end

    def birthday_exist_and_done?(user)
      birthday = Birthday.find_by(celebrant_id: user.id, year: user.next_birthday_year)
      birthday && birthday.done
    end
end
