class BirthdayGenerator
  def call
    User.ordered_by_soonest_birthday
      .where(birthday_month: [Date.today.month, 1.month.from_now, 2.months.from_now, 3.months.from_now])
      .where.not("birthday_month = :month AND birthday_day < :day", { month: Date.today.month, day: Date.today.day } )
      .each do |user|
        unless user.birthdays_as_celebrant.find_by_year(next_birthday_year(user))
          Birthday.create(
            person_responsible: get_next_person_responsible(user),
            celebrant: user,
            year: next_birthday_year(user)
          )
      end
    end
  end

  private
    def next_birthday_date(user)
      Date.new(next_birthday_year(user), user.birthday_month, user.birthday_day)
    end

    def next_birthday_year(user)
      birthday_in_next_year?(user) ? Date.today.year.next : Date.today.year
    end

    def birthday_in_next_year?(user)
      Date.today.month >= user.birthday_month && Date.today.day > user.birthday_day
    end

    def get_next_person_responsible(user)
      previous_person_responsible =
        !user.birthdays_as_celebrant.empty? ?
        user.birthdays_as_celebrant.last.person_responsible_id : nil

      possible_users = User
        .where.not(id: user.id)
        .where.not(id: previous_person_responsible)
      possible_users.sort_by do |user|
        if !user.birthdays_as_person_responsible.where(year: [ Date.today.year, Date.today.year-1 ]).blank?
          user.birthdays_as_person_responsible.where(year: [ Date.today.year, Date.today.year-1 ]).last.created_at
        else
          DateTime.now
        end
      end.last
    end
end
