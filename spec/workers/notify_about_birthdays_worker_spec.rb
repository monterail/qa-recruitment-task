require "rails_helper"

describe NotifyAboutBirthdaysWorker do
  context "notify about birthday" do
    it "is retryable for 3 times" do
      expect(described_class).to be_retryable 3
    end
  end
end
