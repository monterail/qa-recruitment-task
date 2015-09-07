desc "Heroku scheduler"
task :send_birthday_notification => :environment do
  NotificationWorker.perform_async
end
