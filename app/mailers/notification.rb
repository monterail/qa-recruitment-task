class Notification < ApplicationMailer
  def notify_before_birthdays(days, user, celebrant)
    @celebrant = celebrant
    @days = days
    mail(
      to: user.email,
      subject: "It's #{@days} days until #{@celebrant.name} birthday!",
    )
  end

  def notify_about_gifts(celebrant_id, subject, content)
    @celebrant = User.find(celebrant_id)
    @content = content
    mail(
      bcc: User.where.not(id: celebrant_id).pluck(:email),
      subject: subject,
    )
    headers["X-MC-PreserveRecipients"] = "False"
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
