require 'rails_helper'

describe Api::PropositionsController do
  include AuthHelper

  let(:current_user) { User.create!(name: 'hodor', email: 'hodor@example.com', sso_id: '12345678') }
  let(:jubilat) { User.create!(name: 'jubilat', email: 'jubilat@ju.la', sso_id: '12343241') }
  let(:proposition_attributes) {{ 'id' => 222, 'title' => 'title', 'jubilat_id' => jubilat['id'], 'owner_id' => current_user.id }}

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
        auth(User.create!(name: 'baduser', email: 'bad@user.eu', sso_id: '87654321'))
        proposition_attributes['description'] = 'newDescription'
        put :update, id: proposition_attributes['id'], proposition: proposition_attributes
        expect(response.status).to eq(401)
      end
    end
  end
end
