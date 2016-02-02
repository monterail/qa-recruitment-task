class NotifyAboutBirthdaysWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  sidekiq_retry_in do |count|
    (3600 * 2) * (count + 1)
  end

  def perform(user_id, celebrant_id)
    celebrant = User.participating.find(celebrant_id)
    user = User.participating.find(user_id)
    Notification
      .notify_before_birthdays(
        days_till_birthday(celebrant),
        user,
        celebrant,
      )
      .deliver_now
  end

  private

  def days_till_birthday(celebrant)
    (celebrant.next_birthday_date - Time.zone.today).to_i
  end
end
