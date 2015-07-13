require 'rails_helper'

describe Api::BirthdaysController do
  include AuthHelper

  let(:current_user) { User.create!(name: 'hodor', email: 'hodor@example.com', sso_id: '12345678') }
  let(:celebrant) { User.create!(name: 'celebrant', email: 'celebrant@ju.la', sso_id: '12343241', birthday_day: 14, birthday_month: 1.month.from_now.month) }
  let(:proposition) { Proposition.create!(title: 'title', celebrant_id: celebrant['id'], owner_id: current_user.id) }
  let(:comment_attributes) {{ 'id' => 123, 'body' => 'body', 'proposition_id' => proposition['id'], 'owner_id' => current_user.id }}

  before(:each) do
    auth(current_user)
  end

  describe "patch #mark_as_done" do
    it "marks birthday as done" do
      Birthday.create!(celebrant: celebrant, person_responsible: current_user, year: celebrant.next_birthday_year)
      patch :mark_as_done, celebrant_id: User.find_by(sso_id: celebrant['sso_id']).id
      birthday = Birthday.find_by(celebrant: celebrant, year: celebrant.next_birthday_year)
      expect(birthday.done).to eq(true)
    end
  end

  describe "patch #mark_as_undone" do
    it "marks birthday as undone" do
      Birthday.create!(celebrant: celebrant, person_responsible: current_user, year: celebrant.next_birthday_year)
      patch :mark_as_undone, celebrant_id: User.find_by(sso_id: celebrant['sso_id']).id
      birthday = Birthday.find_by(celebrant: celebrant, year: celebrant.next_birthday_year)
      expect(birthday.done).to eq(false)
    end
  end
end
