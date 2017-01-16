class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  RESPONSIBLE_USERS_LIMIT = 16
  has_many :propositions_as_owner, class_name: Proposition,
                                   foreign_key: :owner_id,
                                   dependent: :destroy
  has_many :propositions_as_celebrant, class_name: Proposition,
                                       foreign_key: :celebrant_id, dependent: :destroy
  has_many :birthdays_as_person_responsible, class_name: Birthday,
                                             foreign_key: :person_responsible_id,
                                             dependent: :destroy
  has_many :birthdays_as_celebrant, class_name: Birthday,
                                    foreign_key: :celebrant_id,
                                    dependent: :destroy
  has_many :comments, foreign_key: :owner_id, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :birthday_month, allow_nil: true, numericality: { only_integer: true,
                                                              greater_than: 0,
                                                              less_than_or_equal_to: 12 }
  validates :birthday_day, allow_nil: true, numericality: { only_integer: true,
                                                            greater_than: 0,
                                                            less_than_or_equal_to: 31 }

  scope :ordered_by_soonest_birthday, lambda {
    order(next_birthday_month_case_query, birthday_day: :asc)
  }

  scope :participating, lambda {
    where(participating: true)
  }

  scope :sooners, lambda {
    User.ordered_by_soonest_birthday.participating.where.not(birthday_month: nil, birthday_day: nil)
  }

  scope :without_birthday, lambda {
    User.participating.where("birthday_day IS NULL OR birthday_month IS NULL")
  }

  def next_birthday_date
    Date.new(next_birthday_year, birthday_month, birthday_day)
  end

  def next_birthday_year
    self.birthday_in_next_year? ? Time.zone.today.year.next : Time.zone.today.year
  end

  def birthday_in_next_year?
    Time.zone.today.month >= birthday_month && Time.zone.today.day > birthday_day || next_year?
  end

  def next_year?
    last_birthday = birthdays_as_celebrant.last
    return false unless last_birthday.present?

    Time.zone.today.year.next == last_birthday.year
  end

  def next_birthday
    birthdays_as_celebrant.find_by(year: next_birthday_year)
  end

  def self.next_birthday_month_case_query
    <<-SQL
    CASE
      WHEN #{Time.zone.today.month} < birthday_month THEN birthday_month
      WHEN #{Time.zone.today.month} = birthday_month THEN
        CASE
          WHEN #{Time.zone.today.day} <= birthday_day THEN birthday_month
          ELSE birthday_month+12
        END
      ELSE birthday_month+12
    END
    SQL
  end

  def self.next_user_responsible(celebrant)
    select_user_responsible(celebrant) || select_user_responsible(celebrant, 0)
  end

  def self.select_user_responsible(celebrant, limit = RESPONSIBLE_USERS_LIMIT)
    user_responsible_id = <<-SQL
      SELECT id FROM users WHERE participating = true
      AND id NOT IN (
        SELECT person_responsible_id FROM birthdays
        WHERE person_responsible_id IS NOT NULL
        ORDER BY assigned_at DESC LIMIT #{limit.to_i}
      )
      AND id != #{celebrant.id} ORDER BY random() LIMIT 1
    SQL

    id = ActiveRecord::Base.connection.execute(user_responsible_id).first.try(:[], "id")
    return unless id

    find id
  end
end
