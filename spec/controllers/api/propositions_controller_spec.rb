require 'rails_helper'

describe Api::PropositionsController do
  include AuthHelper

  let(:current_user) { controller.current_user }
  let(:another_user) { User.create!(name: 'another_user', email: 'another@example.com',
                                    sso_id: '049523498') }
  let(:celebrant) { User.create!(name: 'celebrant', email: 'celebrant@ju.la', sso_id: '12343241') }
  let(:proposition_attributes) {{ 'id' => 222, 'title' => 'title', 'celebrant_id' => celebrant['id'], 'owner_id' => current_user.id }}

  describe "post #create" do
    it "new proposition has owner" do
      post :create, proposition: proposition_attributes
      created_proposition = JSON.parse(response.body)
      expect(created_proposition["owner"]).to eq(current_user.attributes.slice("id", "name"))
    end
    it "creates new proposition" do
      expect{ post :create, proposition: proposition_attributes }.to change{ Proposition.count }.by(1)
    end
  end

  describe "put #update" do

    before(:each) do
      Proposition.create(proposition_attributes)
    end

    context "if owner is current_user" do
      it "updates proposition" do
        proposition_attributes['description'] = 'updated description'
        put :update, id: proposition_attributes['id'], proposition: proposition_attributes
        updated_proposition = JSON.parse(response.body)
        expect(updated_proposition['description']).to eq('updated description')
      end

      it "doesn't update proposition with invalid data" do
        proposition_attributes['title'] = nil
        put :update, id: proposition_attributes['id'], proposition: proposition_attributes
        expect(response.status).to eq(422)
      end
    end

    context "if owner isn't current_user" do
      it "return unauthorized" do
        other_propo_attributes = { 'title' => 'title', 'celebrant_id' => celebrant['id'], 'owner_id' => another_user.id }
        other_propo = Proposition.create!(other_propo_attributes)
        other_propo_attributes['description'] = 'newDescription'
        put :update, id: other_propo.id, proposition: other_propo_attributes
        expect(response.status).to eq(401)
      end
    end

    it "heads 404 when proposition not found" do
      put :update, id: 9999, proposition: proposition_attributes
      expect(response.status).to eq(404)
    end
  end

  describe "put #choose" do
    it "assigns current year to proposition" do
      Proposition.create(proposition_attributes)
      put :choose, id: proposition_attributes['id'], proposition: proposition_attributes
      chosen_proposition = JSON.parse(response.body)
      expect(chosen_proposition['year_chosen_in']).to eq(Time.now.year)
    end

    it "heads 404 when proposition not found" do
      put :choose, id: 9999, proposition: proposition_attributes
      expect(response.status).to eq(404)
    end
  end
end
