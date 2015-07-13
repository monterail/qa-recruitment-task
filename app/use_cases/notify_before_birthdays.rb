class NotifyBeforeBirthdays
  def call
    when_to_notify = [1, 5, 15, 30]
    User
      .ordered_by_soonest_birthday
      .where.not(birthday_month: nil, birthday_day: nil)
      .each do |user|
        if when_to_notify.include? days_till_birthday(user)
          unless birthday(user) && birthday(user).done
            NotifyAboutBirthdaysWorker.perform_async(user.id)
          end
        end
    end
  end

  private
    def days_till_birthday(user)
      (user.next_birthday_date - Date.today).to_i
    end

    def birthday(user)
      Birthday.find_by(celebrant_id: user.id, year: user.next_birthday_year)
    end
end
