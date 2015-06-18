class BirthdayGenerator
  def call
    celebrants = soon_to_be_celebrants
    assign_people_responsible_to_celebrants(celebrants)
  end

  private
    def soon_to_be_celebrants
      User.ordered_by_soonest_birthday
        .where( birthday_month: 4.times.map{ |i| i.months.from_now.month } )
        .where.not("birthday_month = :month AND birthday_day < :day", { month: Date.today.month, day: Date.today.day } )
    end

    def assign_people_responsible_to_celebrants(celebrants)
      celebrants.each do |celebrant|
        unless celebrant.birthdays_as_celebrant.find_by_year(celebrant.next_birthday_year)
          assign_person_responsible_to_celebrant(celebrant)
        end
      end
    end

    def assign_person_responsible_to_celebrant(celebrant)
      Birthday.create(
        person_responsible: get_next_person_responsible(celebrant),
        celebrant: celebrant,
        year: celebrant.next_birthday_year
      )
    end

    def get_next_person_responsible(celebrant)
      # Here we want to select first person responsible fitting those criteria:
      # - celebrant can't be his own person responsible
      # - don't have birthdays created as person responsible
      # - or had, but we care only about one
      # - prefer the person with the least birthdays as person resposible
      User
        .where.not(id: celebrant.id)
        .joins('LEFT JOIN (SELECT DISTINCT ON(person_responsible_id) * FROM birthdays) as bd ON bd.person_responsible_id = users.id')
        .group('users.id')
        .order('COUNT(bd.id) ASC')
        .first
    end
end
