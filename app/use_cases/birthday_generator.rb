class BirthdayGenerator
  def call
    User.ordered_by_soonest_birthday
      .where(birthday_month: [Date.today.month, 1.month.from_now, 2.months.from_now, 3.months.from_now])
      .where.not("birthday_month = :month AND birthday_day < :day", { month: Date.today.month, day: Date.today.day } )
      .each do |user|
        unless user.birthdays_as_celebrant.find_by_year!(next_birthday_date(user).year)
          Birthday.create(
            person_responsible: pick_a_person_responsible(user),
            celebrant: user,
            year: next_birthday_date(user).year
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
