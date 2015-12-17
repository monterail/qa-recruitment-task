require "rails_helper"
require "rspec/query_limit"

describe Birthday do
  describe "::upcoming_birthdays" do
    let(:first_of_november_date) { Time.zone.local(2015, 11, 1) }
    let(:fifth_of_november_date) { Time.zone.local(2015, 11, 5) }
    let(:first_of_december_date) { Time.zone.local(2015, 12, 1) }
    let(:independence_day) { Time.zone.local(2015, 11, 11) }
    let(:next_year_january) { Time.zone.local(2016, 1, 1) }
    let(:independence_day_user) do
      User.create(email: "birthday_userexample.com",
                  name: "birthday_user",
                  birthday_month: independence_day.month,
                  birthday_day: independence_day.day,
                  sso_id: "birthday_user1234")
    end
    let(:first_of_december_user) do
      User.create(email: "first_of_december_userexample.com",
                  name: "first_of_december_user",
                  birthday_month: first_of_december_date.month,
                  birthday_day: first_of_december_date.day,
                  sso_id: "first_of_december_user1234")
    end
    let(:next_year_january_user) do
      User.create(email: "next_year_january_userexample.com",
                  name: "next_year_january_user",
                  birthday_month: next_year_january.month,
                  birthday_day: next_year_january.day,
                  sso_id: "next_year_january_user1234")
    end
    let(:first_of_november_user) do
      User.create(email: "first_of_november_userexample.com",
                  name: "first_of_november_user",
                  birthday_month: first_of_november_date.month,
                  birthday_day: first_of_november_date.day,
                  sso_id: "first_of_november_user1234")
    end
    let(:independence_day_bday) do
      described_class.create(person_responsible: first_of_december_user,
                             celebrant: independence_day_user,
                             year: independence_day.year)
    end
    let(:first_of_december_bday) do
      described_class.create(person_responsible: independence_day_user,
                             celebrant: first_of_december_user,
                             year: first_of_december_date.year)
    end
    let(:next_year_january_bday) do
      described_class.create(person_responsible: first_of_november_user,
                             celebrant: next_year_january_user,
                             year: next_year_january.year)
    end
    let(:first_of_november_bday) do
      described_class.create(person_responsible: next_year_january_user,
                             celebrant: first_of_november_user,
                             year: first_of_november_date.year)
    end

    subject do
      Timecop.freeze(fifth_of_november_date) do
        described_class.upcoming_birthdays.pluck(:id)
      end
    end

    before(:each) do
      independence_day_bday
      first_of_december_bday
      next_year_january_bday
      first_of_november_bday
    end

    it "includes birthdays in the future" do
      expected_birthdays = [independence_day_bday.id,
                            first_of_december_bday.id,
                            next_year_january_bday.id,
                           ]
      is_expected.to match_array(expected_birthdays)
    end

    it "doesn't include birthdays from the past" do
      is_expected.not_to include(first_of_november_bday.id)
    end
  end
end
