module AuthHelper
  def auth_as(user)
    RailsSso.profile_mock = user
    warden = double(authenticate!: true, user: RailsSso.profile_mock.as_json)
    request.env['warden'] = warden
    FindOrCreateUser.new.call(RailsSso.profile_mock.as_json)
  end
end
