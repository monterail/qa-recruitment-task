class User < ActiveRecord::Base
  has_many :propositions_as_owner, class_name: Proposition,
                                   foreign_key: :owner_id, dependent: :destroy
  has_many :propositions_as_celebrant, class_name: Proposition,
                                       foreign_key: :celebrant_id, dependent: :destroy
  has_many :birthdays_as_person_responsible, class_name: Birthday,
                                             foreign_key: :person_responsible_id
  has_many :birthdays_as_celebrant, class_name: Birthday, foreign_key: :celebrant_id

  validates :name, presence: true
  validates :email, presence: true
  validates :birthday_month, allow_nil: true, numericality: { only_integer: true,
                                                              greater_than: 0,
                                                              less_than_or_equal_to: 12 }
  validates :birthday_day, allow_nil: true, numericality: { only_integer: true,
                                                            greater_than: 0,
                                                            less_than_or_equal_to: 31 }

  scope :ordered_by_soonest_birthday, lambda {
    order(
      "CASE
        WHEN #{Time.zone.today.month} < birthday_month THEN birthday_month
        WHEN #{Time.zone.today.month} = birthday_month THEN
          CASE
            WHEN #{Time.zone.today.day} <= birthday_day THEN birthday_month
            ELSE birthday_month+12
          END
        ELSE birthday_month+12
      END")
      .order(birthday_day: :asc)
  }

  scope :sooners, lambda { |uid|
    User.ordered_by_soonest_birthday.where.not(sso_id: uid, birthday_month: nil, birthday_day: nil)
  }

  scope :without_birthday, lambda { |uid|
    User.where.not(sso_id: uid).where("birthday_day IS NULL OR birthday_month IS NULL")
  }

  def next_birthday_date
    Date.new(next_birthday_year, birthday_month, birthday_day)
  end

  def next_birthday_year
    self.birthday_in_next_year? ? Time.zone.today.year.next : Time.zone.today.year
  end

  def birthday_in_next_year?
    Time.zone.today.month >= birthday_month && Time.zone.today.day > birthday_day
  end

  def next_birthday
    birthdays_as_celebrant.find_by(year: next_birthday_year)
  end
end
