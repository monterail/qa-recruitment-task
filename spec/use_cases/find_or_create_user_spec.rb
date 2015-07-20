require 'rails_helper'

describe BirthdayGenerator do
  # We always need at least 2 people so we have an option to create a birthday
  let!(:dawid) { User.create(email: 'dawid@example.com', name: 'dawid', sso_id: '23456789') }
  let!(:hodak) { User.create(email: 'hodak@example.com', name: 'hodak', sso_id: '23456790') }
  let(:jakub) { User.create(email: 'jakub@example.com', name: 'jakub', sso_id: '23456791') }
  let!(:current_user_data) {{ "id" => 1, "name" => "hodor", "email" => "hodor@example.com", "uid" => "12345678" }}

  context "if current user exists in born" do
    before(:each) do
      FindOrCreateUser.new(current_user_data).call
    end
    it "updates born user" do
      current_user_data["email"] = "new_changed@ema.il"
      FindOrCreateUser.new(current_user_data).call
      expect(current_user_data["email"]).to eq("new_changed@ema.il")
    end
  end
  context "if current user doesn't exist in born" do
    it "creates new user" do
      expect{ FindOrCreateUser.new(current_user_data).call }.to change{ User.count }.by(1)
    end
  end
end
