class NotifyAboutGiftsWorker
  include Sidekiq::Worker

  def perform(celebrant_id, subject, content)
    celebrant = User.find(celebrant_id)
    Notification
      .notify_about_gift(
        User.where.not(id: celebrant.id),
        celebrant,
        subject,
        content
      )
      .deliver_now
  end
end
