class FindOrCreateUser
  def call(auth_hash)
    attrs = {
      sso_id: auth_hash['uid'],
      name: auth_hash['name'],
      email: auth_hash['email']
    }
    if user = User.find_by(sso_id: attrs['sso_id'])
      user.update_attributes!(attrs)
      user
    else
      User.create!(attrs)
    end
  end
end
