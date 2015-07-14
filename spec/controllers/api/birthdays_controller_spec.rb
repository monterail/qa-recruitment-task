require 'rails_helper'

describe Api::BirthdaysController do
  include AuthHelper

  let(:current_user) { User.create!(name: 'hodor', email: 'hodor@example.com', sso_id: '12345678') }
  let(:celebrant) do
    User.create!(name: 'celebrant', email: 'celebrant@ju.la', sso_id: '12343241',
                 birthday_day: 14, birthday_month: 1.month.from_now.month)
  end

  before(:each) do
    auth(current_user)
    Birthday.create!(
      celebrant: celebrant, person_responsible: current_user,
      year: celebrant.next_birthday_year
    )
  end

  describe "patch #mark_as_done" do
    it "marks birthday as done" do
      patch :mark_as_done, celebrant_id: celebrant.id
      birthday = celebrant.next_birthday
      expect(birthday.done).to eq(true)
    end
  end

  describe "patch #mark_as_undone" do
    it "marks birthday as undone" do
      patch :mark_as_undone, celebrant_id: celebrant.id
      birthday = celebrant.next_birthday
      expect(birthday.done).to eq(false)
    end
  end
end
