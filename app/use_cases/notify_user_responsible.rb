class NotifyUserResponsible
  DAYS_BEFORE_NOTIFICATIONS = 30

  def call
    selected_user_ids.each do |birthday|
      NotifyUserResponsibleWorker.perform_async(
        birthday["person_responsible_id"],
        birthday["celebrant_id"],
      )
    end
  end

  private

  def selected_user_ids
    return [] unless birthday_ids.present?
    query = <<-SQL
      SELECT birthdays.person_responsible_id, birthdays.celebrant_id FROM birthdays
        LEFT OUTER JOIN users ON birthdays.celebrant_id = users.id
        WHERE birthdays.id IN (#{birthday_ids.join(',')})
        AND (TO_DATE(CONCAT_WS('-', users.birthday_day, users.birthday_month, birthdays.year)
        , 'DD-MM-YYYY') - integer '#{DAYS_BEFORE_NOTIFICATIONS}') = current_date
        AND birthdays.covered = false
    SQL

    ActiveRecord::Base.connection.execute(query)
  end

  def birthday_ids
    @birthday_ids ||=
      Birthday.upcoming_birthdays.where.not(celebrant_id: nil, person_responsible_id: nil).ids
  end
end
