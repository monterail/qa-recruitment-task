class BirthdayGenerator
  def call
    celebrants = soon_to_be_celebrants
    assign_people_responsible_to_celebrants(celebrants)
  end

  private
    def soon_to_be_celebrants
      User.ordered_by_soonest_birthday
        .where(birthday_month: [Date.today.month, 1.month.from_now.month, 2.months.from_now.month, 3.months.from_now.month])
        .where.not("birthday_month = :month AND birthday_day < :day", { month: Date.today.month, day: Date.today.day } )
    end

    def assign_people_responsible_to_celebrants(celebrants)
      celebrants.each do |celebrant|
        unless celebrant.birthdays_as_celebrant.find_by_year(next_birthday_year(celebrant))
          assign_person_responsible_to_celebrant(celebrant)
        end
      end
    end

    def assign_person_responsible_to_celebrant(celebrant)
      Birthday.create(
        person_responsible: get_next_person_responsible(celebrant),
        celebrant: celebrant,
        year: next_birthday_year(celebrant)
      )
    end

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
