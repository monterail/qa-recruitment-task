require 'rails_helper'

describe User do
  let(:user) { User.create!(email: "hodor@hodor.eu", name: "hodor", sso_id: "12345") }
  let!(:current_user_data) {{ "id" => 1, "name" => "hodor", "email" => "hodor@example.com", "uid" => "12345678" }}

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

  describe "user#self.auth!" do
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
end
