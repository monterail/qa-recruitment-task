require 'rails_helper'

describe Api::CommentsController do
  include AuthHelper

  let(:current_user) { User.create!(name: 'hodor', email: 'hodor@example.com', sso_id: '12345678') }
  let(:jubilat) { User.create!(name: 'jubilat', email: 'jubilat@ju.la', sso_id: '12343241') }
  let!(:proposition) { Proposition.create!(title: 'title', jubilat_id: jubilat['id'], owner_id: current_user.id) }
  let(:comment_attributes) {{ 'id' => 123, 'body' => 'body', 'proposition_id' => proposition['id'], 'owner_id' => current_user.id }}

  before(:each) do
    auth(current_user)
  end

  describe "post #create" do
    it "new comment has owner" do
      post :create, proposition_id: comment_attributes['proposition_id'], comment: comment_attributes
      created_comment = JSON.parse(response.body)
      expect(created_comment['owner']).to eq(current_user.attributes.slice('id', 'name'))
    end

    it "creates new comment" do
      expect{ post :create, proposition_id: comment_attributes['proposition_id'], comment: comment_attributes }.to change{ Comment.count }.by(1)
    end
  end

  describe "put #update" do
    before(:each) do
      Comment.create(comment_attributes)
    end

    context "if owner is current_user" do
      it "updates comment" do
        comment_attributes['body'] = 'new body'
        put :update, proposition_id: comment_attributes['proposition_id'], id: comment_attributes['id'], comment: comment_attributes
        updated_comment = JSON.parse(response.body)
        expect(updated_comment['body']).to eq('new body')
      end

      it "doesn't update comment with invalid data" do
        comment_attributes['value'] = 'stringInsteadOfNumber'
        put :update, proposition_id: comment_attributes['proposition_id'], id: comment_attributes['id'], comment: comment_attributes
        updated_comment = JSON.parse(response.body)
        expect(updated_comment['body']).not_to eq('stringInsteadOfNumber')
        updated_comment = Comment.find(comment_attributes['id'])
        expect(updated_comment['body']).not_to eq('stringInsteadOfNumber')
      end
    end
    context "if owner isn't current_user" do
      it "return unauthorized" do
        auth(User.create!(name: 'baduser', email: 'bad@user.eu', sso_id: '87654321'))
        comment_attributes['body'] = 'new body'
        put :update, proposition_id: comment_attributes['proposition_id'], id: comment_attributes['id'], comment: comment_attributes
        expect(response.status).to eq(401)
      end
    end
  end
end
