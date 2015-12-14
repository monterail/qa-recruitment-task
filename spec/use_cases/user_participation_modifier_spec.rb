require "rails_helper"

describe UserParticipationModifier do
  let(:today_date) { Time.zone.today }

  let!(:birthday_owner) do
    User.create(email: "birthday_owner@example.com",
                name: "birthday_owner",
                birthday_month: today_date.month,
                birthday_day: (today_date.day + 1),
                sso_id: "birthday_owner1234")
  end
  let!(:gift_responsible) do
    User.create(email: "gift_responsible@example.com",
                name: "gift_responsible",
                sso_id: "gift_responsible1234")
  end
  let!(:participating_user) do
    User.create(email: "participating_user@example.com",
                name: "participating_user",
                sso_id: "participating_user1234")
  end
  describe "call" do
    context "changes user to" do
      subject { User.participating.pluck(:email) }
      it "participate in the birthdays event" do
        User.create(email: "not_participating@example.com",
                    name: "not_participating",
                    birthday_month: 1,
                    birthday_day: 1,
                    is_participating: false,
                    sso_id: "not_participating1234")
        described_class.new.call(["not_participating@example.com"], true)
        is_expected.to include("not_participating@example.com")
      end

      it "not participate in the birthdays event" do
        described_class.new.call(["birthday_owner@example.com"], false)
        is_expected.not_to include("birthday_owner@example.com")
      end
    end
    context "when the birthday is still to come" do
      let!(:birthday) do
        Birthday.create(person_responsible: gift_responsible,
                        celebrant: birthday_owner,
                        year: today_date.year)
      end
      before(:each) do
        Timecop.freeze(today_date) do
          described_class.new.call(["gift_responsible@example.com"], false)
        end
      end
      it "removes the gift responsability from the user" do
        gift_responsible_birthdays =
          gift_responsible.birthdays_as_person_responsible.pluck(:id)
        expect(gift_responsible_birthdays).not_to include(Birthday.last.id)
      end

      it "sets the responsability of the gift to another user" do
        participating_user_birhtdays =
          participating_user.birthdays_as_person_responsible.pluck(:id)
        expect(participating_user_birhtdays).to include(birthday.id)
      end
    end
    context "when the birthday has passed already " do
      let!(:birthday) do
        Birthday.create(person_responsible: gift_responsible,
                        celebrant: birthday_owner,
                        year: today_date.year)
      end
      before(:each) do
        birthday_owner.update_attribute(:birthday_day, (today_date.day - 1))
        Timecop.freeze(today_date) do
          described_class.new.call(["gift_responsible@example.com"], false)
        end
      end
      it "does not change the responsible of the birthday owner" do
        birthdays_ids_from_person_responsible =
          gift_responsible.birthdays_as_person_responsible.pluck(:id)
        expect(birthdays_ids_from_person_responsible).to include(birthday.id)
      end
      it "does not add the responsibility to any other user" do
        birthdays_ids_from_participating_user =
          participating_user.birthdays_as_person_responsible.pluck(:id)
        expect(birthdays_ids_from_participating_user).not_to include(birthday.id)
      end
    end
  end
end
