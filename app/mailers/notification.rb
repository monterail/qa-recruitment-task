class Notification < ApplicationMailer
  def notify_before_birthdays(days, user, celebrant)
    @celebrant = celebrant
    @days = days
    mail(
      to: user.email,
      subject: "It's #{@days} days until #{@celebrant.name} birthday!",
    )
  end

  def notify_about_gifts(users, celebrant, subject, content)
    @celebrant = celebrant
    @content = content
    mail(
      to: users.first["email"],
      bcc: users.where.not(id: users.first["id"]).map(&:email),
      subject: subject,
    )
  end

  def notify_responsible_persons(days, user, celebrant)
    @celebrant = celebrant
    @days = days
    mail(
      to: user.email,
      subject: "It's #{@days} days until #{@celebrant.name} birthday!",
    )
  end
end
