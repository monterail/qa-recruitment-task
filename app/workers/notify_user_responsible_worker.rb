class NotifyUserResponsibleWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3
  sidekiq_retry_in do |count|
    (3600 * 2) * (count + 1)
  end

  def perform(user_id, celebrant_id)
    user = User.participating.find(user_id)
    celebrant = User.participating.find(celebrant_id)

    Notification.notify_responsible_user(user, celebrant).deliver_now
  end
end
