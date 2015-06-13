require 'rails_helper'

describe BirthdayGenerator do

  describe "celebrants are chosen from next 3 months" do
    context "valid celebrants" do
      after(:each) do
        expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(1)
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
        time_febraury = Time.local(2015, 2, 1, 16, 37, 0)
        Timecop.freeze(time_febraury)
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
      end
    end

    context "invalid celebrants" do
      after(:each) do
        expect{ BirthdayGenerator.new.call }.to change{ Birthday.count }.by(0)
        Timecop.return
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
        time_febraury = Time.local(2015, 2, 4, 16, 37, 0)
        Timecop.freeze(time_febraury)
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
      end
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
