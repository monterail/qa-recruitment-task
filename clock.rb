require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(1.day, 'birthday.notification', :at => '07:00') do
    BirthdayGenerator.new.call
    NotifyBeforeBirthdays.new.call
  end
end
