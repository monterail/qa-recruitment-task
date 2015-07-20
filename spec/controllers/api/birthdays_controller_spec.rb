require 'rails_helper'

describe Api::BirthdaysController, type: :controller do
  include AuthHelper

  let(:celebrant) do
    User.create!(name: 'celebrant', email: 'celebrant@ju.la', sso_id: '12343241',
                 birthday_day: 14, birthday_month: 1.month.from_now.month)
  end
  let(:current_user) { controller.current_user }

  before(:each) do
    Birthday.create!(
      celebrant: celebrant, person_responsible: current_user,
      year: celebrant.next_birthday_year
    )
  end

  describe "patch #mark_as_covered" do
    it "marks birthday as covered" do
      patch :mark_as_covered, celebrant_id: celebrant.id
      birthday = celebrant.next_birthday
      expect(birthday.covered).to eq(true)
    end
  end

  describe "patch #mark_as_uncovered" do
    it "marks birthday as uncovered" do
      patch :mark_as_uncovered, celebrant_id: celebrant.id
      birthday = celebrant.next_birthday
      expect(birthday.covered).to eq(false)
    end
  end
end
