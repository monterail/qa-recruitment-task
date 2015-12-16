require "rails_helper"
require "rspec/query_limit"

describe Birthday do
  describe '#upcoming_birthdays' do
    let(:first_of_november_date) { Time.zone.local(2015, 11, 1) }
    let(:fifth_of_november_date) { Time.zone.local(2015, 11, 5) }
    let(:first_of_december_date) { Time.zone.local(2015, 12, 1) }
    let(:independence_date) { Time.zone.local(2015, 11, 11) }
    let(:next_year_january_date) { Time.zone.local(2016, 1, 1) }

    context "when the birthday is in" do
      subject do
        Timecop.freeze(fifth_of_november_date) do
          described_class.upcoming_birthdays.pluck(:id)
        end
      end

      it "the same year and month but days later" do
        user = User.create(email: "birthday_user@example.com",
                           name: "birthday_user",
                           birthday_month: independence_date.month,
                           birthday_day: independence_date.day,
                           sso_id: "birthday_user1234")
        bday = described_class.create(person_responsible: user,
                                      celebrant: user,
                                      year: independence_date.year)
        is_expected.to include(bday.id)
      end

      it "the same year but months later" do
        user = User.create(email: "birthday_user@example.com",
                           name: "birthday_user",
                           birthday_month: first_of_december_date.month,
                           birthday_day: first_of_december_date.day,
                           sso_id: "birthday_user1234")
        bday = described_class.create(person_responsible: user,
                                      celebrant: user,
                                      year: first_of_december_date.year)
        is_expected.to include(bday.id)
      end

      it "the next year" do
        user = User.create(email: "birthday_user@example.com",
                           name: "birthday_user",
                           birthday_month: next_year_january_date.month,
                           birthday_day: next_year_january_date.day,
                           sso_id: "birthday_user1234")
        bday = described_class.create(person_responsible: user,
                                      celebrant: user,
                                      year: next_year_january_date.year)
        is_expected.to include(bday.id)
      end

      it "some date before " do
        user = User.create(email: "birthday_user@example.com",
                           name: "birthday_user",
                           birthday_month: first_of_november_date.month,
                           birthday_day: first_of_november_date.day,
                           sso_id: "birthday_user1234")
        bday = described_class.create(person_responsible: user,
                                      celebrant: user,
                                      year: first_of_november_date.year)
        is_expected.not_to include(bday.id)
      end
    end
  end
end
