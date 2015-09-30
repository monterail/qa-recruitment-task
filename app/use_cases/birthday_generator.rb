class BirthdayGenerator
  def call
    celebrants = soon_to_be_celebrants
    assign_people_responsible_to_celebrants(celebrants)
  end

  private

  def soon_to_be_celebrants
    User.ordered_by_soonest_birthday
      .where(birthday_month: 4.times.map { |i| i.months.from_now.month })
      .where.not("birthday_month = :month AND birthday_day < :day", { month: Date.today.month, day: Date.today.day })
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
      year: celebrant.next_birthday_year,
    )
  end

  def get_next_person_responsible(celebrant)
    # Here we want to select first person responsible fitting those criteria:
    # - celebrant can't be his own person responsible
    # - first we want people who haven't taken care of birthday in the last or current year
    #   or haven't birthdays planned in the future
    # - we want to sort instead of exclude users because we always need someone to be picked
    User
      .where.not(id: celebrant.id)
      .sort_by do |user|
        if !user.birthdays_as_person_responsible.where(year: (-1..1).map { |i| i.years.ago.year }).blank?
          user.birthdays_as_person_responsible.where(year: (-1..1).map { |i| i.years.ago.year }).last.created_at
        else
          DateTime.now
        end
      end
      .last
  end
end
