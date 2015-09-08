desc "Sends notification about incoming birthdays, assigns people responsible for celebrants"
task :send_birthday_notification => :environment do
  NotificationWorker.perform_async
end
