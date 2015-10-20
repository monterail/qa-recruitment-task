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

  def notify_responsible_persons(days, user, celebrant)
    @celebrant = celebrant
    @days = days
    mail(
      to: user.email,
      subject: "Have you bought gift for #{@celebrant.name}? It's #{@days} days left.",
    )
  end
end
