class NotifyResponsiblePersonWorker
  include Sidekiq::Worker

  def perform(user_id, celebrant_id)
    celebrant = User.find(celebrant_id)
    user = User.find(user_id)
    Notification
      .notify_responsible_persons(
        days_till_birthday(celebrant),
        user,
        celebrant,
      )
      .deliver_now
  end

  def days_till_birthday(celebrant)
    (celebrant.next_birthday_date - Time.zone.today).to_i
  end
end
