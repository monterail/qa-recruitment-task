require "rails_helper"

describe NotifyResponsiblePersonWorker do
  context "notify about responsibility" do
    it "is retryable for 3 times" do
      expect(described_class).to be_retryable 3
    end
  end
end
