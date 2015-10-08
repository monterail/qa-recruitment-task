class NotifyAboutGiftsWorker
  include Sidekiq::Worker

  def perform(user_id, celebrant_id, subject, content)
    celebrant = User.find(celebrant_id)
    user = User.find(user_id)
    Notification
      .notify_about_gifts(
        user,
        celebrant,
        subject,
        content,
      )
      .deliver_now
  end
end
