require 'rails_helper'

describe Api::UsersController do
  include AuthHelper

  let!(:current_user_data) {{ "id" => 1, "name" => "hodor", "email" => "hodor@example.com", "uid" => "12345678" }}
  let!(:current_user) { User.create!(name: 'hodor', email: 'hodor@example.com', sso_id: '12345678') }
  let!(:user_younger) { User.create!(email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789', birthday_month:  12, birthday_day: 1) }
  let!(:user_older) { User.create!(email: 'hodor3@example.com', name: 'hodor3', sso_id: '34567890', birthday_month: 2, birthday_day: 12) }
  let!(:user_without_birthday) { User.create!(email: 'hodor4@example.com', name: 'hodor4', sso_id: '45678901') }

  before(:each) do
    auth(current_user_data)
  end

  after(:each) { expect(response).to be_success }

  describe "GET #edit" do
    it "returns current_user data" do
      request.accept = "application/json"
      get :edit, :format => :json
      user_shown = JSON.parse(response.body)
      expect(user_shown["email"]).to eq current_user["email"]
    end
  end

  describe "GET #index" do
    before(:each) do
      get :index, :format => :json
      @user = JSON.parse(response.body)
    end

    subject { @user }

    it "returns users without current_user" do
      is_expected.not_to include(current_user.as_json)
    end

    it "returns users sorted by earliest birthday" do
      is_expected.to eq([user_older.as_json, user_younger.as_json])
    end

    it "doesn't include users without birthday date" do
      is_expected.not_to include(user_without_birthday.as_json)
    end
  end

  describe "PUT #update" do
    let!(:invalid_user) {{ "id" => nil, "email" => "hodor", "sso_id" => "12345678" }}
    context "with valid attributes" do

      it "updates current_user data" do
        current_user.update_attribute(:birthday_day, 12)
        put :update, :user => current_user.as_json
        updated_user = JSON.parse(response.body)
        expect(updated_user["birthday_day"]).to eq(12)
      end
    end
    context "with invalid attributes" do

      it "doesn't update current_user data" do
        put :update, :user => invalid_user.as_json
        updated_user = JSON.parse(response.body)
        expect(updated_user).not_to eq(invalid_user.as_json)
      end
      it "doesn't let update email" do
        current_user['email'] = 'new_email@test.es'
        put :update, :user => current_user.as_json
        updated_user = JSON.parse(response.body)
        expect(updated_user["email"]).to eq("hodor@example.com")
      end
    end
  end
end
