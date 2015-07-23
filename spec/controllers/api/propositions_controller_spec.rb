require 'rails_helper'

describe Api::PropositionsController do
  include AuthHelper

  let(:current_user) { User.create!(name: 'hodor', email: 'hodor@example.com', sso_id: '12345678') }
  let(:celebrant) { User.create!(name: 'celebrant', email: 'celebrant@ju.la', sso_id: '12343241') }
  let(:proposition_attributes) {{ 'id' => 222, 'title' => 'title', 'celebrant_id' => celebrant['id'], 'owner_id' => current_user.id }}

  before(:each) do
    auth(current_user)
  end

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
      Proposition.create!(proposition_attributes)
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
        auth(User.create!(name: 'baduser', email: 'bad@user.eu', sso_id: '87654321'))
        proposition_attributes['description'] = 'newDescription'
        put :update, id: proposition_attributes['id'], proposition: proposition_attributes
        expect(response.status).to eq(401)
      end
    end

    it "heads 404 when proposition not found" do
      put :update, id: 'xyz', proposition: proposition_attributes
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
      put :choose, id: 'xyz', proposition: proposition_attributes
      expect(response.status).to eq(404)
    end
  end

  describe "put #unchoose" do
    it "assigns nil to proposition" do
      Proposition.create(proposition_attributes)
      put :choose, id: proposition_attributes['id'], proposition: proposition_attributes
      put :unchoose, id: proposition_attributes['id'], proposition: proposition_attributes
      chosen_proposition = JSON.parse(response.body)
      expect(chosen_proposition['year_chosen_in']).to eq(nil)
    end

    it "heads 404 when proposition not found" do
      put :unchoose, id: 'xyz', proposition: proposition_attributes
      expect(response.status).to eq(404)
    end
  end

  describe "delete #destroy" do
    before(:each) do
      Proposition.create!(proposition_attributes)
    end

    context "if owner is current_user" do
      it "deletes proposition" do
        delete :destroy, id: proposition_attributes['id'], proposition: proposition_attributes
        expect(response.status).to eq(200)
        expect(Proposition.find_by(id: proposition_attributes['id'])).to be_nil
      end
    end

    context "if owner isn't current_user" do
      it "return unauthorized" do
        auth(User.create!(name: 'baduser', email: 'bad@user.eu', sso_id: '87654321'))
        delete :destroy, id: proposition_attributes['id'], proposition: proposition_attributes
        expect(response.status).to eq(401)
      end
    end

    it "heads 404 when comment not found" do
      delete :destroy, id: 'xyz', proposition: proposition_attributes
      expect(response.status).to eq(404)
    end
  end
end
