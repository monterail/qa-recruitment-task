class NotifyAboutGiftsWorker
  include Sidekiq::Worker

  def perform(celebrant_id, subject, content)
    Notification
      .notify_about_gifts(
        celebrant_id,
        subject,
        content,
      )
      .deliver_now
  end
end
