class BirthdayGenerator
  def call
    celebrants = soon_to_be_celebrants
    assign_people_responsible_to_celebrants(celebrants)
  end

  private

  def soon_to_be_celebrants
    User.ordered_by_soonest_birthday
      .where(birthday_month: 4.times.map { |i| i.months.from_now.month })
      .where.not("birthday_month = :month AND birthday_day < :day",
                 month: Time.zone.today.month, day: Time.zone.today.day)
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
      person_responsible: User.next_user_responsible(celebrant),
      celebrant: celebrant,
      year: celebrant.next_birthday_year,
    )
  end
end
