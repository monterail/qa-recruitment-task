require "rails_helper"

describe Api::CommentsController do
  include AuthHelper

  let(:current_user) { controller.current_user }
  let(:another_user) do
    User.create!(name: "another_user", email: "another@example.com",
                 sso_id: "049523498")
  end
  let(:celebrant) do
    User.create!(name: "celebrant", email: "celebrant@ju.la",
                 sso_id: "12343241")
  end
  let(:proposition) do
    Proposition.create!(title: "title", celebrant_id: celebrant["id"],
                        owner_id: current_user.id)
  end
  let(:comment_attributes) do
    { "id" => 123, "body" => "body",
      "proposition_id" => proposition["id"],
      "owner_id" => current_user.id }
  end

  describe "post #create" do
    it "new comment has owner" do
      post :create, proposition_id: comment_attributes["proposition_id"],
                    comment: comment_attributes
      created_comment = JSON.parse(response.body)
      expect(created_comment["owner"]["id"]).to eq(current_user.id)
    end

    it "creates new comment" do
      expect do
        post :create, proposition_id: comment_attributes["proposition_id"],
                      comment: comment_attributes
      end.to change { Comment.count }.by(1)
    end

    it "heads 404 when proposition not found" do
      post :create, proposition_id: 9999, comment: comment_attributes
      expect(response.status).to eq(404)
    end
  end

  describe "put #update" do
    before(:each) do
      Comment.create!(comment_attributes)
    end

    context "if owner is current_user" do
      it "updates comment" do
        comment_attributes["body"] = "new body"
        put :update, proposition_id: comment_attributes["proposition_id"],
                     id: comment_attributes["id"], comment: comment_attributes
        updated_comment = JSON.parse(response.body)
        expect(updated_comment["body"]).to eq("new body")
      end

      it "doesn't update comment with invalid data" do
        comment_attributes["body"] = nil
        put :update, proposition_id: comment_attributes["proposition_id"],
                     id: comment_attributes["id"], comment: comment_attributes
        expect(response.status).to eq(422)
      end
    end

    context "if owner isn't current_user" do
      it "return unauthorized" do
        other_comment_attributes = { "body" => "body", "proposition_id" => proposition["id"],
                                     "owner_id" => another_user.id }
        other_comment = Comment.create!(other_comment_attributes)
        comment_attributes["body"] = "new body"
        put :update, proposition_id: other_comment.proposition_id,
                     id: other_comment.id, comment: other_comment_attributes
        expect(response.status).to eq(401)
      end
    end

    it "heads 404 when comment not found" do
      put :update, proposition_id: comment_attributes["proposition_id"],
                   id: 9999, comment: comment_attributes
      expect(response.status).to eq(404)
    end
  end

  describe "delete #destroy" do
    before(:each) do
      Comment.create!(comment_attributes)
    end

    context "if owner is current_user" do
      it "deletes comment" do
        delete :destroy, proposition_id: comment_attributes["proposition_id"],
                         id: comment_attributes["id"]
        expect(response.status).to eq(200)
        expect(Comment.find_by(id: comment_attributes["id"])).to be_nil
      end
    end

    context "if owner isn't current_user" do
      it "return unauthorized" do
        other_comment = Comment.create!(body: "body", proposition_id: proposition["id"],
                                        owner_id: another_user.id)
        delete :destroy, proposition_id: other_comment.proposition_id,
                         id: other_comment.id
        expect(response.status).to eq(401)
      end
    end

    it "heads 404 when comment not found" do
      delete :destroy, proposition_id: comment_attributes["proposition_id"], id: "xyz"
      expect(response.status).to eq(404)
    end
  end
end
