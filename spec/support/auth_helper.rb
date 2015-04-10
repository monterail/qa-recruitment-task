module AuthHelper
  def auth(user)
    allow(controller).to receive(:user_signed_in?).and_return(:true)
    allow(controller).to receive(:current_user_data).and_return(user)
  end
end
