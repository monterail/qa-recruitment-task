require "rails_helper"
require "rspec/query_limit"

describe User do
  let(:user) { described_class.create!(email: "hodor@hodor.eu", name: "hodor", sso_id: "12345") }

  it "has a valid factory" do
    expect(user).to be_valid
  end
  it "is invalid without name" do
    user.update_attribute(:name, "")
    expect(user).to be_invalid
  end
  it "is invalid without email" do
    user.update_attribute(:email, "")
    expect(user).to be_invalid
  end

  describe "birthday_month" do
    context "is valid" do
      after(:each) { expect(user).to be_valid }
      it "when 1" do
        user.update_attribute(:birthday_month, 1)
      end
      it "when 12" do
        user.update_attribute(:birthday_month, 12)
      end
    end
    context "is invalid" do
      after(:each) { expect(user).to be_invalid }
      it "when -1" do
        user.update_attribute(:birthday_month, -1)
      end
      it "when 0" do
        user.update_attribute(:birthday_month, 0)
      end
      it "when 13" do
        user.update_attribute(:birthday_month, 13)
      end
    end
  end

  describe "birthday_month" do
    context "is valid" do
      after(:each) { expect(user).to be_valid }
      it "when 1" do
        user.update_attribute(:birthday_day, 1)
      end
      it "when 31" do
        user.update_attribute(:birthday_day, 31)
      end
    end
    context "is invalid" do
      after(:each) { expect(user).to be_invalid }
      it "when -1" do
        user.update_attribute(:birthday_day, -1)
      end
      it "when 0" do
        user.update_attribute(:birthday_day, 0)
      end
      it "when 32" do
        user.update_attribute(:birthday_day, 32)
      end
    end
  end

  describe "User.sooners scope" do
    let(:current_user_data) do
      { "id" => 1, "name" => "hodor", "email" => "hodor@example.com", "uid" => "12345678" }
    end

    before(:each) do
      FindOrCreateUser.new(current_user_data).call
    end

    after(:each) do
      Timecop.return
    end

    subject { described_class.sooners }

    it { expect { described_class.sooners.to_a }.to query_limit_eq(1) }

    describe "order" do
      context "regarding yesterday/today/tomorrow" do
        it "is today, tomorrow, yesterday" do
          user_yesterday = described_class.create(id: 126, email: "hodor2@example.com",
                                                  name: "hodor2", sso_id: "23456789",
                                                  birthday_month: Date.yesterday.month,
                                                  birthday_day: Date.yesterday.day)
          user_today = described_class.create(id: 127, email: "hodor2@example.com",
                                              name: "hodor2", sso_id: "23456789",
                                              birthday_month: Time.zone.today.month,
                                              birthday_day: Time.zone.today.day)
          user_tomorrow = described_class.create(id: 128, email: "hodor2@example.com",
                                                 name: "hodor2", sso_id: "23456789",
                                                 birthday_month: Date.tomorrow.month,
                                                 birthday_day: Date.tomorrow.day)

          is_expected.to eq([user_today, user_tomorrow, user_yesterday])
        end
      end

      context "regarding months" do
        it "is earlier, later" do
          user_earlier = described_class.create(email: "febraury@example.com", name: "earlier",
                                                birthday_month: 1.month.from_now.month,
                                                birthday_day: 1, sso_id: "earlier456")
          user_later = described_class.create(email: "later@example.com", name: "later",
                                              birthday_month: 2.month.from_now.month,
                                              birthday_day: 1, sso_id: "later789")
          is_expected.to eq([user_earlier, user_later])
        end
      end

      context "regarding days" do
        it "is earlier, later" do
          user_12 = described_class.create(email: "younger@example.com", name: "younger",
                                           birthday_month: 1.month.from_now.month,
                                           birthday_day: 12, sso_id: "younger1234")
          user_14 = described_class.create(email: "older@example.com", name: "older",
                                           birthday_month: 1.month.from_now.month,
                                           birthday_day: 14, sso_id: "older5678")
          is_expected.to eq([user_12, user_14])
        end
      end

      context "regarding end of the year" do
        it "is by earliest date" do
          user_december = described_class.create(email: "december@example.com", name: "december",
                                                 birthday_month: 12, birthday_day: 31,
                                                 sso_id: "december123")
          user_january = described_class.create(email: "january@example.com", name: "january",
                                                birthday_month: 1, birthday_day: 1,
                                                sso_id: "january123")
          user_april = described_class.create(email: "april@example.com", name: "april",
                                              birthday_month: 4, birthday_day: 15,
                                              sso_id: "april123")
          time_febraury = Time.zone.local(2015, 2, 1, 16, 37, 0)
          Timecop.freeze(time_febraury)
          is_expected.to eq([user_april, user_december, user_january])
        end
      end
    end

    describe "excluding users" do
      it "excludes not participating users" do
        not_participating_user = described_class.create(email: "not_participating@example.com",
                                                        name: "not_participating",
                                                        birthday_month: 1,
                                                        birthday_day: 1,
                                                        participating: false,
                                                        sso_id: "not_participating1234")
        is_expected.not_to include(not_participating_user)
      end

      it "excludes current user" do
        is_expected.not_to include(current_user_data
          .slice("name", "id", "birthday_day", "birthday_month"))
      end

      it "excludes users without birthday date" do
        user_without_birthday = described_class.create(email: "without@example.com",
                                                       name: "without",
                                                       sso_id: "without1234")
        is_expected.not_to include(user_without_birthday
          .slice("name", "id", "birthday_day", "birthday_month"))
      end
    end
  end
end
