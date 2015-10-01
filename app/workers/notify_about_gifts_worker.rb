class NotifyAboutGiftsWorker
  include Sidekiq::Worker

  def perform(celebrant_id, subject, content)
    celebrant = User.find(celebrant_id)
    User.where.not(id: celebrant.id).each do |user|
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
end
