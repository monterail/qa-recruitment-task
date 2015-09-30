class NotifyAboutBirthdaysWorker
  include Sidekiq::Worker

  def perform(celebrant_id)
    celebrant = User.find(celebrant_id)
    Notification
      .notify_before_birthdays(
        days_till_birthday(celebrant),
        User.where.not(id: celebrant.id),
        celebrant,
      )
      .deliver_now
  end

  private

  def days_till_birthday(user)
    (user.next_birthday_date - Time.zone.today).to_i
  end
end
