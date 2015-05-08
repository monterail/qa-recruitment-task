require 'rails_helper'

describe Api::UsersController do
  include AuthHelper

  let(:current_user_attributes) {{ 'id' => 123, 'name' => 'hodor', 'email' => 'hodor@example.com', 'sso_id' => '12345678' }}
  let(:user_younger_attributes) {{ 'id' => 124, 'email' => 'hodor2@example.com', 'name' => 'hodor2', 'sso_id' => '23456789', 'birthday_month' => 12, 'birthday_day' => 1 }}
  let(:user_older_attributes) {{ 'id' => 125, 'email' => 'hodor3@example.com', 'name' => 'hodor3', 'sso_id' => '34567890', 'birthday_month' => 2, 'birthday_day' => 12 }}
  let(:user_without_birthday_attributes) {{ 'email' => 'hodor4@example.com', 'name' => 'hodor4', 'sso_id' => '45678901' }}

  before(:each) do
    auth(User.create(current_user_attributes))
  end

  after(:each) do |it|
    unless it.metadata[:skip_after]
      expect(response).to be_success
    end
  end

  describe "GET #me" do
    it "returns current_user_attributes data" do
      get :me
      user_shown = JSON.parse(response.body)
      expect(user_shown['email']).to eq(current_user_attributes['email'])
    end
  end

  describe "GET #index" do
    before(:each) do
      User.create(user_older_attributes)
      User.create(user_younger_attributes)
      User.create(user_without_birthday_attributes)
      get :index
    end

    subject { JSON.parse(response.body) }

    it "returns users without current_user_attributes" do
      is_expected.not_to include(current_user_attributes.slice('name', 'id', 'birthday_day', 'birthday_month'))
    end

    it "returns users sorted by earliest birthday" do
      expect(subject[0]['id']).to eq(user_older_attributes['id'])
      expect(subject[1]['id']).to eq(user_younger_attributes['id'])
    end

    it "doesn't include users without birthday date" do
      is_expected.not_to include(user_without_birthday_attributes.slice('name', 'id', 'birthday_day', 'birthday_month'))
    end
  end

  describe "PUT #update_me" do
    context "with valid attributes" do
      it "updates current_user_attributes data" do
        current_user_attributes['birthday_day'] = 12
        put :update_me, user: current_user_attributes
        updated_user = JSON.parse(response.body)
        expect(updated_user['birthday_day']).to eq(12)
        updated_user = User.find_by_id(current_user_attributes['id'])
        expect(updated_user['birthday_day']).to eq(12)
      end
    end

    context "with invalid attributes" do
      it "doesn't update current_user data" do
        current_user_attributes['birthday_day'] = 'hodor'
        put :update_me, user: current_user_attributes
        updated_user = JSON.parse(response.body)
        expect(updated_user['birthday_day']).not_to eq('hodor')
        updated_user = User.find_by_id(current_user_attributes['id'])
        expect(updated_user['birthday_day']).not_to eq('hodor')
      end

      it "doesn't let update email" do
        current_user_attributes['email'] = 'new_email@test.es'
        put :update_me, user: current_user_attributes
        updated_user = JSON.parse(response.body)
        expect(updated_user["email"]).to eq("hodor@example.com")
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "updates user data" do
        User.create(user_younger_attributes)
        user_younger_attributes['about'] = 'about_text'
        put :update, id: user_younger_attributes['id'], user: user_younger_attributes
        updated_user = JSON.parse(response.body)
        expect(updated_user['about']).to eq('about_text')
      end
    end
    context "with invalid attributes" do
      let(:invalid_user) {{ 'email' => 'hodor', 'sso_id' => '12345678' }}

      it "doesn't update current_user_attributes data" do
        User.create(user_younger_attributes)
        put :update, id: user_younger_attributes['id'], user: user_younger_attributes
        updated_user = JSON.parse(response.body)
        expect(updated_user['email']).not_to eq('hodor')
      end

      it "doesn't let update email" do
        User.create(user_younger_attributes)
        user_younger_attributes['email'] = 'new_email@test.es'
        put :update, id: user_younger_attributes['id'], user: user_younger_attributes
        updated_user = JSON.parse(response.body)
        expect(updated_user['email']).to eq('hodor2@example.com')
      end
    end
  end

  describe "GET #show" do
    let!(:chosen_proposition) { Proposition.create!(title: 'title', owner_id: user_younger_attributes['id'], jubilat_id: user_older_attributes['id'], year_chosen_in: 2015) }
    let!(:current_proposition) { Proposition.create!(title: 'title', owner_id: user_younger_attributes['id'], jubilat_id: user_older_attributes['id']) }
    let!(:comment) { Comment.create!(body: 'body', owner_id: user_younger_attributes['id'], proposition_id: current_proposition['id']) }

    context "shows user's data" do
      before(:each) do
        User.create(user_older_attributes)
        User.create(user_younger_attributes)
      end

      it "shows user's previously chosen propositions" do
        get :show, id: user_older_attributes['id']
        user_shown = JSON.parse(response.body)
        expect(user_shown['propositions']['chosen']).to eq([PropositionRepresenter.new(chosen_proposition).basic.as_json])
      end

      it "shows user's current propositions" do
        get :show, id: user_older_attributes['id']
        user_shown = JSON.parse(response.body)
        expect(user_shown['propositions']['current']).to eq([PropositionRepresenter.new(current_proposition).basic.as_json])
      end

      it "shows comments to current propositions" do
        get :show, id: user_older_attributes['id']
        user_shown = JSON.parse(response.body)
        expect(user_shown['propositions']['current'].first['comments']).to eq([CommentRepresenter.new(comment).basic.as_json])
      end

      it "shows person_responsible for current birthday" do
        user_younger = User.find_by_id(user_younger_attributes['id'])
        user_younger.update_attributes(person_responsible_id: user_older_attributes['id'])
        get :show, id: user_younger_attributes['id']
        user_shown = JSON.parse(response.body)
        expect(user_shown['person_responsible']['id']).to eq(user_older_attributes['id'])
      end
    end

    it "doesn't show user's data if it's current_user_attributes", skip_after: true do
      get :show, id: current_user_attributes['id']
      expect(response.status).to eq(401)
    end
  end
end
