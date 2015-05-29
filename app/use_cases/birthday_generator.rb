class BirthdayGenerator
  def call
    users = User.all.order(
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

    users.each do |user|
      break if next_birthday_date(user) > 3.months.from_now
      unless user.birthdays_as_celebrant.find_by_year(Date.today.year)
        Birthday.create(
          person_responsible: pick_a_person_responsible(user),
          celebrant: user,
          year: Date.today.year
        )
      end
    end
  end

  private
    def next_birthday_date(user)
      Date.new(
        if Date.today.month >= user.birthday_month
          if Date.today.day > user.birthday_day
            Date.today.year + 1
          else
            Date.today.year
          end
        else
          Date.today.year
        end,
        user.birthday_month,
        user.birthday_day
      )
    end

    def pick_a_person_responsible(user)
      previous_people_responsible = user.birthdays_as_celebrant.map do |birthday|
        birthday.person_responsible_id
      end

      possible_users = User.where.not(id: previous_people_responsible).where.not(id: user.id)
      possible_users.sort_by do |user|
        if !user.birthdays_as_person_responsible.blank?
          user.birthdays_as_person_responsible.last.created_at
        else
          DateTime.now
        end
      end.last
    end
end
