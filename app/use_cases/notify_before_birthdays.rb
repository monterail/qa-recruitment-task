class NotifyBeforeBirthdays
  def call
    when_to_notify = [1, 6, 15, 30]
    User.ordered_by_soonest_birthday.each do |user|
      if when_to_notify.include? days_till_birthday(user)
        unless user.done
          Notification.notify_before_birthdays(
            days_till_birthday(user),
            User.where.not(id: user.id),
            user
          ).deliver_now
        end
      end
    end
  end

  private
    def days_till_birthday(user)
      (user.next_birthday_date - Date.today).to_i
    end
end
