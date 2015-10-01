class NotifyAboutBirthdaysWorker
  include Sidekiq::Worker

  def perform(celebrant_id)
    celebrant = User.find(celebrant_id)
    User.where.not(id: celebrant.id).each do |user|
      Notification
        .notify_before_birthdays(
          days_till_birthday(celebrant),
          user,
          celebrant,
        )
        .deliver_now
    end
  end

  private

  def days_till_birthday(user)
    (user.next_birthday_date - Time.zone.today).to_i
  end
end
