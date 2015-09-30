class ApplicationMailer < ActionMailer::Base
  default from: ENVied.MAILER_SENDER
  layout "mailer"
  helper CelebrantHelper
end
