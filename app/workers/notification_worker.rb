class NotificationWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3
  sidekiq_retry_in do |count|
    (3600 * 2) * (count + 1)
  end

  def perform
    BirthdayGenerator.new.call
    NotifyBeforeBirthdays.new.call
    NotifyUserResponsible.new.call
  end
end
