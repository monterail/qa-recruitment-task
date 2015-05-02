class CurrentUserRepresenter < Struct.new(:user)
  def basic
    {
      id: user["id"],
      name: user["name"],
      email: user["email"],
      birthday_day: user["birthday_day"],
      birthday_month: user["birthday_month"],
      szama: user["szama"]
    }
  end
end
