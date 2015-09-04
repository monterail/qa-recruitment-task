require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'birthday.notification', :at => '07:00') do
    NotificationWorker.perform_async
  end
end
