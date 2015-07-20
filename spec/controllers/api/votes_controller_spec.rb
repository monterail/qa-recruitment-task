require 'rails_helper'

describe Api::VotesController do
  include AuthHelper

  let(:current_user) { User.find_by(sso_id: controller.current_user_data['uid']) }
  let(:celebrant) { User.create!(name: 'celebrant', email: 'celebrant@ju.la', sso_id: '12343241') }
  let(:proposition) { Proposition.create!(id: 222, title: 'title', celebrant_id: celebrant.id, owner_id: current_user.id) }

  describe "post #vote" do
    it "adds vote to proposition" do
      expect {
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
      expect {
        post :vote, id: proposition.id
      }.to_not change{ proposition.votes.count }
      expect(response.status).to eq(403)
    end

    it "forbids celebrant to vote" do
      auth_as(celebrant.attributes.merge(:uid => celebrant.sso_id))
      post :vote, id: proposition.id
      expect {
        post :vote, id: proposition.id
      }.not_to change{ proposition.votes.count }
      expect(response.status).to eq(403)
    end

    it "heads 404 when proposition not found" do
      post :vote, id: 9999
      expect(response.status).to eq(404)
    end
  end

  describe "delete #unvote" do
    it "doesn't allow to delete another user's vote" do
      other_users_vote = Vote.create(user_id: 4, proposition_id: proposition.id)
      delete :unvote, id: proposition.id, vote_id: other_users_vote.id
      expect(response.status).to eq(401)
    end

    it "deletes a vote" do
      vote = Vote.create(user_id: current_user.id, proposition_id: proposition.id)
      expect {
        delete :unvote, id: proposition.id, vote_id: vote.id
      }.to change{ proposition.votes.count }.by(-1)
    end

    it "heads 404 when vote not found" do
      delete :unvote, id: proposition.id, vote_id: 9999
      expect(response.status).to eq(404)
    end
  end
end
