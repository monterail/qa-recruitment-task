class BirthdayGenerator
  def call
    celebrants = soon_to_be_celebrants
    assign_people_responsible_to_celebrants(celebrants)
  end

  private
    def soon_to_be_celebrants
      User.ordered_by_soonest_birthday
        .where(
          birthday_month: 4.times.map{ |i| i.months.from_now.month }
        )
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
      User
        .joins('LEFT JOIN birthdays ON birthdays.person_responsible_id = users.id')
        .where('birthdays.person_responsible_id IS NULL OR birthdays.created_at > :year_ago', year_ago: 1.year.ago)
        .group('users.id')
        .order("COUNT(birthdays.id) ASC")
        .limit(1)
        .first
    end
end
