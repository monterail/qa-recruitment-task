class Birthday < ActiveRecord::Base
  belongs_to :celebrant, class_name: User, foreign_key: :celebrant_id
  belongs_to :person_responsible, class_name: User, foreign_key: :person_responsible_id

  validates :celebrant, presence: true
  validates :person_responsible, presence: true
  validates :celebrant, uniqueness: { scope: :year }

  scope :upcoming_birthdays, lambda {
    joins(:celebrant)
      .where("( year = :today_year AND "\
             "  ( users.birthday_month = :today_month AND "\
             "    users.birthday_day > :today_day)"\
             "  OR (users.birthday_month > :today_month))"\
             "OR (year > :today_year)",
             today_year: Time.zone.today.year,
             today_month: Time.zone.today.month,
             today_day: Time.zone.today.day,
            )
  }

  def person_responsible_id=(val)
    super(val)
    self.assigned_at = Time.zone.now
  end
end
