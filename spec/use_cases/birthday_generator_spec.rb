require 'rails_helper'

describe BirthdayGenerator do

  describe "celebrants are chosen from next 3 months" do
    after(:each) do
      Timecop.return
    end

    it "current month but after today" do
      celebrant = User.create(
        id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
        birthday_month: 2,
        birthday_day: 20
      )
      person_responsible = User.create(
        id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790'
      )
      time_febraury = Time.local(Date.today.year, 2, 1, 16, 37, 0)
      Timecop.freeze(time_febraury)
      expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(1)
    end

    it "1 month from now" do
      celebrant = User.create(
        id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
        birthday_month: 1.month.from_now.month,
        birthday_day: 1
      )
      person_responsible = User.create(
        id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790'
      )
      expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(1)
    end

    it "3 month from now" do
      celebrant = User.create(
        id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
        birthday_month: 3.month.from_now.month,
        birthday_day: 1
      )
      person_responsible = User.create(
        id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790'
      )
      expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(1)
    end

    it "1 month ago" do
      celebrant = User.create(
        id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
        birthday_month: 1.month.ago.month,
        birthday_day: 1
      )
      person_responsible = User.create(
        id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790'
      )
      expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(0)
    end

    it "current month but before today" do
      celebrant = User.create(
        id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
        birthday_month: 2,
        birthday_day: 2
      )
      person_responsible = User.create(
        id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790'
      )
      time_febraury = Time.local(Date.today.year, 2, 4, 16, 37, 0)
      Timecop.freeze(time_febraury)
      expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(0)
    end

    it "4 months from now" do
      celebrant = User.create(
        id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
        birthday_month: 4.month.from_now.month,
        birthday_day: 1
      )
      person_responsible = User.create(
        id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790'
      )
      expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(0)
    end

    it "2 months from now, but next year" do
      celebrant = User.create(
        id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
        birthday_month: 1,
        birthday_day: 2
      )
      person_responsible = User.create(
        id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790'
      )
      time_november = Time.local(Date.today.year, 11, 4, 16, 37, 0)
      Timecop.freeze(time_november)
      expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(1)
    end
  end

  it "doesn't create new birthday if there is already a birthday for this celebrant" do
    celebrant = User.create(
      id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
      birthday_month: 1.month.from_now.month,
      birthday_day: 1
    )
    person_responsible = User.create(
      id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790'
    )
    expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(1)
    expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(0)
  end

  it "creates 2 Birthdays when there are 2 free celebrants" do
    first_celebrant = User.create(
      id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
      birthday_month: 1.month.from_now.month,
      birthday_day: 1
    )
    second_celebrant = User.create(
      id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790',
      birthday_month: 2.month.from_now.month,
      birthday_day: 1
    )
    expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(2)
  end

  it "assigns a person responsible even when every possible person responsible took care of some birthday already" do
    first = User.create(
      id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
      birthday_month: 1.month.from_now.month,
      birthday_day: 1
    )
    second = User.create(
      id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790',
      birthday_month: 2.month.from_now.month,
      birthday_day: 1
    )
    third = User.create(
      id: 128, email: 'hodor4@example.com', name: 'hodor4', sso_id: '23456791',
      birthday_month: 2.month.from_now.month,
      birthday_day: 14
    )
    Birthday.create(
      celebrant: first,
      person_responsible: second,
      year: Date.today.year
    )
    Birthday.create(
      celebrant: second,
      person_responsible: first,
      year: Date.today.year
    )
    BirthdayGenerator.new.call
    birthday = Birthday.find_by!(celebrant_id: third.id, year: Date.today.year)
    expect(birthday.year).to eq(Date.today.year)
  end

  describe "person responsible when choosing has the least birhtdays as person responsible in the last year" do
    context "had couple birthdays long time ago" do
      let!(:celebrant) { User.create(
        id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
        birthday_month: 1.month.from_now.month,
        birthday_day: 1
      )}
      let!(:person_responsible_that_had_birthday_long_time_ago) { User.create(
        id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790',
        birthday_month: 2.month.from_now.month, birthday_day: 1
      )}
      let!(:person_responsible_that_had_birthday_recently) { User.create(
        id: 128, email: 'hodor4@example.com', name: 'hodor3', sso_id: '23456791'
      )}

      it "assigns person_responsible_that_had_birthday_long_time_ago" do
        time_2_years_ago = Time.local(2.years.ago.year, 1, 1, 16, 37, 0)
        Timecop.freeze(time_2_years_ago)
        Birthday.create(
          celebrant: celebrant,
          person_responsible: person_responsible_that_had_birthday_long_time_ago,
          year: Date.today.year
        )
        Timecop.return
        time_3_years_ago = Time.local(3.years.ago.year, 1, 1, 16, 37, 0)
        Timecop.freeze(time_3_years_ago)
        Birthday.create(
          celebrant: celebrant,
          person_responsible: person_responsible_that_had_birthday_long_time_ago,
          year: Date.today.year
        )
        Timecop.return
        Birthday.create(
          celebrant: person_responsible_that_had_birthday_long_time_ago,
          person_responsible: person_responsible_that_had_birthday_recently,
          year: Date.today.year
        )
        BirthdayGenerator.new.call
        birthday = Birthday.find_by!(celebrant_id: celebrant.id, year: Date.today.year)
        expect(birthday.person_responsible.id).to eq(person_responsible_that_had_birthday_long_time_ago.id)
      end
    end

    context "had no birthdays yet" do
      let!(:celebrant) { User.create(
        id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789',
        birthday_month: 1.month.from_now.month,
        birthday_day: 1
      )}
      let(:person_responsible_that_had_birthday_twice_this_year) { User.create(
        id: 127, email: 'hodor3@example.com', name: 'hodor3', sso_id: '23456790'
      )}
      let(:person_responsible_that_had_no_birthday_yet) { User.create(
        id: 128, email: 'hodor3@example.com', name: 'hodor4', sso_id: '23456791'
      )}

      it "assigns person_responsible_that_had_no_birthday_yet" do
        Birthday.create(
          celebrant: person_responsible_that_had_no_birthday_yet,
          person_responsible: person_responsible_that_had_birthday_twice_this_year,
          year: Date.today.year
        )
        Birthday.create(
          celebrant: person_responsible_that_had_no_birthday_yet,
          person_responsible: person_responsible_that_had_birthday_twice_this_year,
          year: Date.today.year
        )
        BirthdayGenerator.new.call
        birthday = Birthday.find_by(celebrant_id: celebrant.id, year: Date.today.year)
        expect(birthday.person_responsible.id).to eq(person_responsible_that_had_no_birthday_yet.id)
      end
    end
  end
end
