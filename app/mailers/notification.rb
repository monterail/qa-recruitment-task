class Notification < ApplicationMailer
  def notify_before_birthdays(days, users, celebrant)
    @celebrant = celebrant
    @days = days
    @users = users
    mail(
      to: users.map(&:email),
      subject: "It's #{@days} days until #{@celebrant.name} birthday!"
    )
  end
end
