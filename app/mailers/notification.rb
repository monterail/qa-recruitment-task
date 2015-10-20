class Notification < ApplicationMailer
  def notify_before_birthdays(days, user, celebrant)
    @celebrant = celebrant
    @days = days
    mail(
      to: user.email,
      subject: "It's #{@days} days until #{@celebrant.name} birthday!",
    )
  end

  def notify_about_gifts(user, celebrant, subject, content)
    @celebrant = celebrant
    @content = content
    mail(
      to: user.email,
      subject: subject,
    )
  end
end
