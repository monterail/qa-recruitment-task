class NotifyBeforeBirthdays
  DAYS_BEFORE_NOTIFICATIONS = [1, 5, 15, 30]

  def call
    # rubocop:disable Style/Next
    User
      .ordered_by_soonest_birthday
      .where.not(birthday_month: nil, birthday_day: nil)
      .each do |celebrant|
      if DAYS_BEFORE_NOTIFICATIONS.include? days_till_birthday(celebrant)
        unless birthday_exist_and_covered? celebrant
          User.where.not(id: celebrant.id).each do |user|
            NotifyAboutBirthdaysWorker.perform_async(user.id, celebrant.id)
          end
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
