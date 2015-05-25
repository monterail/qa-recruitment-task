require 'rails_helper'
require 'rspec/query_limit'

describe User do
  let(:user) { User.create!(email: "hodor@hodor.eu", name: "hodor", sso_id: "12345") }

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

  describe "User.auth!" do
    let!(:current_user_data) {{ "id" => 1, "name" => "hodor", "email" => "hodor@example.com", "uid" => "12345678" }}

    context "if current user exists in born" do
      before(:each) do
        User.auth!(current_user_data)
      end
      it "updates born user" do
        current_user_data["email"] = "new_changed@ema.il"
        User.auth!(current_user_data)
        expect(current_user_data["email"]).to eq("new_changed@ema.il")
      end
    end
    context "if current user doesn't exist in born" do
      it "creates new user" do
        expect{ User.auth!(current_user_data) }.to change{ User.count }.by(1)
      end
    end
  end

  describe "User.sooners scope" do
    let(:current_user_data) {{ "id" => 1, "name" => "hodor", "email" => "hodor@example.com", "uid" => "12345678" }}

    before(:each) do
      User.auth!(current_user_data)
    end

    after(:each) do
      Timecop.return
    end

    subject { users = User.sooners(current_user_data['sso_id']) }

    it { expect{ User.sooners(current_user_data['sso_id']).to_a }.to query_limit_eq(1) }

    context "is properly ordered" do
      it "regarding yesterday/today/tomorrow" do
        user_yesterday = User.create(id: 126, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789', birthday_month: Date.yesterday.month, birthday_day: Date.yesterday.day )
        user_today = User.create(id: 127, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789', birthday_month: Date.today.month, birthday_day: Date.today.day )
        user_tomorrow = User.create(id: 128, email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789', birthday_month: Date.tomorrow.month, birthday_day: Date.tomorrow.day )

        is_expected.to eq([user_today, user_tomorrow, user_yesterday])
      end

      it "regarding months" do
        user_earlier = User.create(email: 'febraury@example.com', name: 'earlier', sso_id: 'earlier456',
          birthday_month: 1.month.from_now.month, birthday_day: 1)
        user_later = User.create(email: 'later@example.com', name: 'later', sso_id: 'later789',
          birthday_month: 2.month.from_now.month, birthday_day: 1)
        is_expected.to eq([user_earlier, user_later])
      end

      it "regarding days" do
        user_12 = User.create(email: 'younger@example.com', name: 'younger', sso_id: 'younger1234',
          birthday_month: 1.month.from_now.month, birthday_day: 12)
        user_14 = User.create(email: 'older@example.com', name: 'older', sso_id: 'older5678',
          birthday_month: 1.month.from_now.month, birthday_day: 14)
        is_expected.to eq([user_12, user_14])
      end
    end

    it "excludes current user" do
      is_expected.not_to include(current_user_data.slice('name', 'id', 'birthday_day', 'birthday_month'))
    end

    it "excludes users without birthday date" do
      user_without_birthday = User.create(email: 'without@example.com', name: 'without', sso_id:'without1234')
      is_expected.not_to include(user_without_birthday.slice('name', 'id', 'birthday_day', 'birthday_month'))
    end

    it "accepts @hodak's requirements" do
      user_december = User.create(email: 'december@example.com', name: 'december', sso_id: 'december123',
        birthday_month: 12, birthday_day: 31)
      user_january = User.create(email: 'january@example.com', name: 'january', sso_id: 'january123',
        birthday_month: 1, birthday_day: 1)
      user_april = User.create(email: 'april@example.com', name: 'april', sso_id: 'april123',
        birthday_month: 4, birthday_day: 15)
      time_may = Time.local(2015, 5, 1, 16, 37, 0) #it doesn't work here, as we can't mock postgres NOW() method
      Timecop.freeze(time_may)
      is_expected.to eq([user_december, user_january, user_april])
    end
  end
end
