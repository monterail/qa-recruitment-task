class User < ActiveRecord::Base
  validates :name, presence: true
  validates :email, presence: true

  def self.auth!(auth_hash)
    attrs = {
      sso_id: auth_hash['uid'],
      name: auth_hash['name'],
      email: auth_hash['email']
    }
    if user = find_by(sso_id: auth_hash['uid'])
      user.update_attributes!(attrs)
      user
    else
      create!(attrs)
    end
  end
end
