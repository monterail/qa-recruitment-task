require 'rails_helper'

describe Api::UsersController do
  include AuthHelper

  let(:current_user) { User.create!(name: 'hodor', email: 'hodor@example.com', sso_id: '12345678') }
  let!(:user_younger) { User.create!(email: 'hodor2@example.com', name: 'hodor2', sso_id: '23456789', birthday_month:  12, birthday_day: 1) }
  let!(:user_older) { User.create!(email: 'hodor3@example.com', name: 'hodor3', sso_id: '34567890', birthday_month: 2, birthday_day: 12) }
  let!(:user_without_birthday) { User.create!(email: 'hodor4@example.com', name: 'hodor4', sso_id: '45678901') }

  before(:each) do
    auth(current_user)
  end

  after(:each) do |it|
    unless it.metadata[:skip_after]
      expect(response).to be_success
    end
  end

  describe "GET #me" do
    it "returns current_user data" do
      request.accept = "application/json"
      get :me, format: :json
      user_shown = JSON.parse(response.body)
      expect(user_shown["email"]).to eq(current_user["email"])
    end
  end

  describe "GET #index" do
    before(:each) do
      get :index, format: :json
    end

    subject { JSON.parse(response.body) }

    it "returns users without current_user" do
      is_expected.not_to include(current_user.as_json)
    end

    it "returns users sorted by earliest birthday" do
      is_expected.to eq([user_older.attributes.slice("name", "id", "birthday_day", "birthday_month"), user_younger.attributes.slice("name", "id", "birthday_day", "birthday_month")])
    end

    it "doesn't include users without birthday date" do
      is_expected.not_to include(user_without_birthday.as_json)
    end
  end

  describe "PUT #update_me" do
    let!(:invalid_user) {{ "id" => nil, "email" => "hodor", "sso_id" => "12345678" }}
    context "with valid attributes" do
      it "updates current_user data" do
        current_user["birthday_day"] = 12
        put :update_me, user: current_user.as_json
        updated_user = JSON.parse(response.body)
        expect(updated_user["birthday_day"]).to eq(12)
      end
    end

    context "with invalid attributes" do
      it "doesn't update current_user data" do
        put :update_me, user: invalid_user.as_json
        updated_user = JSON.parse(response.body)
        expect(updated_user).not_to eq(invalid_user.as_json)
      end
      it "doesn't let update email" do
        current_user['email'] = 'new_email@test.es'
        put :update_me, user: current_user.as_json
        updated_user = JSON.parse(response.body)
        expect(updated_user["email"]).to eq("hodor@example.com")
      end
    end
  end

  describe "PUT #update" do
    let!(:invalid_user) {{ "email" => "hodor", "sso_id" => "12345678" }}
    context "with valid attributes" do
      it "updates user data" do
        user_younger.update_attributes(about: "about_text")
        put :update, id: user_younger["id"], user: user_younger.as_json
        updated_user = JSON.parse(response.body)
        expect(updated_user["about"]).to eq("about_text")
      end
    end
    context "with invalid attributes" do
      it "doesn't update current_user data" do
        put :update, id: user_younger["id"], user: invalid_user.as_json
        updated_user = JSON.parse(response.body)
        expect(updated_user).not_to eq(invalid_user.as_json)
      end
      it "doesn't let update email" do
        user_younger['email'] = 'new_email@test.es'
        put :update, id: user_younger["id"], user: user_younger.as_json
        updated_user = JSON.parse(response.body)
        expect(updated_user["email"]).to eq("hodor2@example.com")
      end
    end
  end

  describe "GET #show" do
    let!(:chosen_proposition) { Proposition.create!(title: 'title', owner_id: user_younger["id"], jubilat_id: user_older["id"], year_chosen_in: 2015) }
    let!(:current_proposition) { Proposition.create!(title: 'title', owner_id: user_younger["id"], jubilat_id: user_older["id"]) }
    let!(:comment) { Comment.create!(body: 'body', owner_id: user_younger["id"], proposition_id: current_proposition["id"]) }
    context "shows user's data" do
      it "shows user's previously chosen propositions" do
        get :show, id: user_older["id"]
        user_shown = JSON.parse(response.body)
        expect(user_shown["propositions"]["chosen"]).to eq([PropositionRepresenter.new(chosen_proposition).basic.as_json])
      end
      it "shows user's current propositions" do
        get :show, id: user_older["id"]
        user_shown = JSON.parse(response.body)
        expect(user_shown["propositions"]["current"]).to eq([PropositionRepresenter.new(current_proposition).basic.as_json])
      end
      it "shows comments to current propositions" do
        get :show, id: user_older["id"]
        user_shown = JSON.parse(response.body)
        expect(user_shown["propositions"]["current"].first["comments"]).to eq([CommentRepresenter.new(comment).basic.as_json])
      end
      it "shows person_responsible for current birthday" do
        user_younger.update_attributes(person_responsible_id: user_older["id"])
        get :show, id: user_younger["id"]
        user_shown = JSON.parse(response.body)
        expect(user_shown["person_responsible"]["id"]).to eq(user_older["id"])
      end
    end
    it "doesn't show user's data if it's current_user", skip_after: true do
      get :show, id: current_user["id"]
      expect(response.status).to eq(401)
    end
  end
end
