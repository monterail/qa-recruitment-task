class User < ActiveRecord::Base
  has_many :propositions, foreign_key: :owner_id, dependent: :destroy
  has_many :propositions, foreign_key: :jubilat, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :birthday_month, allow_nil: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 12 }
  validates :birthday_day, allow_nil: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 31 }

  scope :sooners, -> (uid) { where.not(sso_id: uid, birthday_month: nil, birthday_day: nil).order(birthday_month: :asc) }

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
