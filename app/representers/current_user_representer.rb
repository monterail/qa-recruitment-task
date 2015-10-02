CurrentUserRepresenter = Struct.new(:user) do
  def basic
    {
      id: user.id,
      name: user.name,
      email: user.email,
      birthday_day: user.birthday_day,
      birthday_month: user.birthday_month,
      szama: user.szama,
      profile_photo: "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}",
    }
  end
end
