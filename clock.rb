require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(6.minutes, 'send.mail') do
    Notification.notify_me.deliver_now
    Notification.notify_me_two.deliver_now
  end

  every(1.day, 'birthday.notification', :at => '00:00') do
    BirthdayGenerator.new.call
    NotifyBeforeBirthdays.new.call
  end
end
