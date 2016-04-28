class NotifyAboutGiftsWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3
  sidekiq_retry_in do |count|
    (3600 * 2) * (count + 1)
  end

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
