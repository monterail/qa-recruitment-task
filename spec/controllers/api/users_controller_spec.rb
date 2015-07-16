require 'rails_helper'

describe Api::UsersController do
  include AuthHelper

  let(:current_user_attributes) {{ 'id' => 123, 'name' => 'hodor', 'email' => 'hodor@example.com', 'sso_id' => '12345678' }}
  let(:user_younger_attributes) {{ 'id' => 124, 'email' => 'hodor2@example.com', 'name' => 'hodor2', 'sso_id' => '23456789', 'birthday_month' => 2.month.from_now.month, 'birthday_day' => 1 }}
  let(:user_older_attributes) {{ 'id' => 125, 'email' => 'hodor3@example.com', 'name' => 'hodor3', 'sso_id' => '34567890', 'birthday_month' => 1.month.from_now.month, 'birthday_day' => 12 }}
  let(:user_without_birthday_attributes) {{ 'email' => 'hodor4@example.com', 'name' => 'hodor4', 'sso_id' => '45678901' }}

  before(:each) do
    auth(User.create(current_user_attributes))
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

  describe "GET #users_without_birthday" do
    before(:each) do
      User.create(user_older_attributes)
      User.create(user_without_birthday_attributes)
      get :users_without_birthday
    end

    subject { JSON.parse(response.body) }

    it "returns users wihout current_user_attributes" do
      is_expected.not_to include(current_user_attributes.slice('name', 'id'))
    end

    it "returns users that have no birthday date set up" do
      user_without_birthday = User.find_by(sso_id: user_without_birthday_attributes['sso_id'])
      expect(subject[0]['id']).to eq(user_without_birthday.id)
    end

    it "doesn't include users with birthday date" do
      is_expected.not_to include(user_older_attributes.slice('name', 'id'))
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
      it "doesn't update current_user data when birthday_day is over scale" do
        current_user_attributes['birthday_day'] = 48
        put :update_me, user: current_user_attributes
        expect(response.status).to eq(422)
        updated_user = User.find_by_id(current_user_attributes['id'])
        expect(updated_user['birthday_day']).not_to eq(48)
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
        user_younger_attributes['birthday_day'] = 100
        put :update, id: user_younger_attributes['id'], user: user_younger_attributes
        expect(response.status).to eq(422)
        updated_user = User.find_by_id(user_younger_attributes['id'])
        expect(updated_user.birthday_day).not_to eq(100)
      end

      it "doesn't let update email" do
        User.create(user_younger_attributes)
        user_younger_attributes['email'] = 'new_email@test.es'
        put :update, id: user_younger_attributes['id'], user: user_younger_attributes
        updated_user = JSON.parse(response.body)
        expect(updated_user['email']).to eq('hodor2@example.com')
      end

      it "heads 404 when user not found" do
        put :update, id: 9999, user: user_younger_attributes
        expect(response.status).to eq(404)
      end
    end
  end

  describe "GET #show" do
    let!(:chosen_proposition) { Proposition.create!(title: 'title', owner_id: user_younger_attributes['id'], celebrant_id: user_older_attributes['id'], year_chosen_in: 2015) }
    let!(:current_proposition) { Proposition.create!(title: 'title', owner_id: user_younger_attributes['id'], celebrant_id: user_older_attributes['id']) }
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
        birthday = Birthday.create(
          person_responsible: User.find_by_id(user_older_attributes['id']),
          celebrant: User.find_by_id(user_younger_attributes['id']),
          year: Date.today.year
        )
        get :show, id: user_younger_attributes['id']
        user_shown = JSON.parse(response.body)
        expect(user_shown['person_responsible']['id']).to eq(user_older_attributes['id'])
      end
    end

    it "doesn't show user's data if it's current_user_attributes" do
      get :show, id: current_user_attributes['id']
      expect(response.status).to eq(401)
    end

    it "heads 404 when user not found" do
      get :show, id: 9999
      expect(response.status).to eq(404)
    end
  end
end
