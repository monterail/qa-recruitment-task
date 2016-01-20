require "rails_helper"

describe NotificationWorker do
  context "run BirthdayGenerator and NotifyBeforeBirthdays service" do
    it "is retryable for 5 times" do
      expect(NotificationWorker).to be_retryable 5
    end
  end
end
