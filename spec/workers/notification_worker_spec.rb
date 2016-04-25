require "rails_helper"

describe NotificationWorker do
  context "run BirthdayGenerator and NotifyBeforeBirthdays service" do
    it "is retryable for 3 times" do
      expect(described_class).to be_retryable 3
    end
  end
end
