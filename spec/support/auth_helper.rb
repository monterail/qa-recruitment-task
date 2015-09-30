module AuthHelper
  def auth_as(user)
    request.env["warden"] = warden(user)
    FindOrCreateUser.new(user.as_json).call
  end

  def warden(user)
    double(authenticate!: true,
           authenticated?: true,
           user: user.as_json,
          )
  end
end
