require 'rails_helper'

describe Api::VotesController do
  include AuthHelper

  let(:current_user) { User.create!(name: 'hodor', email: 'hodor@example.com', sso_id: '12345678') }
  let(:proposition) { Proposition.create!(id: 222, title: 'title', celebrant_id: 1, owner_id: current_user.id) }

  before(:each) do
    auth(current_user)
  end

  describe "post #vote" do
    it "adds vote to proposition" do
      expect{
        post :vote, id: proposition.id
      }.to change{ proposition.votes.count }.by(1)
    end
    it "assigns current_user to last vote" do
      post :vote, id: proposition.id
      vote = JSON.parse(response.body)
      expect(vote['user_id']).to eq(current_user.id)
    end
    it "forbids to vote twice for the same proposition" do
      post :vote, id: proposition.id
      expect{
        post :vote, id: proposition.id
      }.to_not change{ proposition.votes.count }
      expect(response.status).to eq(403)
    end
  end
end
