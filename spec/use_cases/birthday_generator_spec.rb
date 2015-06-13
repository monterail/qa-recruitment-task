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

  it "it has the least birthdays as person responsible in the last year"
end
