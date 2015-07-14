class User < ActiveRecord::Base
  has_many :propositions_as_owner, class_name: Proposition, foreign_key: :owner_id, dependent: :destroy
  has_many :propositions_as_celebrant, class_name: Proposition, foreign_key: :celebrant_id, dependent: :destroy
  has_many :birthdays_as_person_responsible, class_name: Birthday, foreign_key: :person_responsible_id
  has_many :birthdays_as_celebrant, class_name: Birthday, foreign_key: :celebrant_id

  validates :name, presence: true
  validates :email, presence: true
  validates :birthday_month, allow_nil: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 12 }
  validates :birthday_day, allow_nil: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 31 }

  scope :ordered_by_soonest_birthday, -> {
    order(
      "CASE
        WHEN #{Date.today.month} < birthday_month THEN birthday_month
        WHEN #{Date.today.month} = birthday_month THEN
          CASE
            WHEN #{Date.today.day} <= birthday_day THEN birthday_month
            ELSE birthday_month+12
          END
        ELSE birthday_month+12
      END")
    .order(birthday_day: :asc)
  }

  scope :sooners, -> (uid) {
    User.ordered_by_soonest_birthday.where.not(sso_id: uid, birthday_month: nil, birthday_day: nil)
  }

  def next_birthday_date
    Date.new(self.next_birthday_year, self.birthday_month, self.birthday_day)
  end

  def next_birthday_year
    self.birthday_in_next_year? ? Date.today.year.next : Date.today.year
  end

  def birthday_in_next_year?
    Date.today.month >= self.birthday_month && Date.today.day > self.birthday_day
  end

  def next_birthday
    self.birthdays_as_celebrant.find_by(year: self.next_birthday_year)
  end

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
