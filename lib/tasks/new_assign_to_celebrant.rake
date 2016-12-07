desc "Reassign persons responsible for birthdays"
task new_assign_to_celebrant: :environment do
  birthdays = Birthday.joins(:celebrant)
    .where("users.birthday_month >= ? and year = ?",
           1.month.from_now.month,
           1.month.from_now.year)

  Birthday.transaction do
    birthdays.find_each do |b|
      b.person_responsible_id = User.next_user_responsible(b.celebrant).id
      b.save!(validate: false)
      puts b.attributes
    end

    puts "New assign person responsible to celebrant was created"
  end
end
