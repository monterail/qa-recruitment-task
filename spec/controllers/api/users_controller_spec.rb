require 'rails_helper'

describe Api::UsersController do
  render_views
  include AuthHelper

  let(:user) {{ "id" => 1, "email" => "hodor@example.com", "sso_id" => "12345678"}}
  #let(:invalid_user) {{ "id" => nil, "email" => "hodor", "sso_id" => "12345678" }}


  before(:each) do
    auth(user)
    current_user = User.create(user)
  end

  describe "GET #show" do
    it "should return current_user data" do
      request.accept = "application/json"
      get :show, :id => 12341234123, :format => :json
      expect(response).to be_success
      user_shown = JSON.parse(response.body)
      expect(user_shown["email"]).to eq valid_user["email"]

    end
  end

  describe "GET #index" do
    it "should return users without current_user"
    it "should return users sorted by earliest birthday"
  end

  describe "PUT #update" do
    context "with valid attributes" do
      it "updates current_user data"
    end
    context "with invalid attributes" do
      it "doesn't update current_user data"
      it "doesn't let update email"
    end
  end
end
