class Notification < ApplicationMailer
  def notify_before_birthdays(days, users, celebrant)
    @celebrant, @days, @users = celebrant, days, users
    mail(
      to: users.map(&:email),
      subject: "It's #{@days} days until #{@celebrant.name} birthday!"
    )
  end

  def notify_about_gifts(users, celebrant, subject, content)
    @celebrant, @content = celebrant, content
    mail(
      to: users.map(&:email),
      subject: subject
    )
  end
end
