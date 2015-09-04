class NotificationWorker
  include Sidekiq::Worker

  def perform
    BirthdayGenerator.new.call
    NotifyBeforeBirthdays.new.call
  end
end
