class UsersRepresenter < Struct.new(:users)
  def basic
    users.map do |user| {
      name: user.name,
      id: user.id,
      birthday_day: user.birthday_day,
      birthday_month: user.birthday_month
      }
    end
  end
end
