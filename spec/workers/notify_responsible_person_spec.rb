require "rails_helper"

describe NotifyResponsiblePersonWorker do
  context "notify about responsibility" do
    it "is retryable for 5 times" do
      expect(NotifyResponsiblePersonWorker).to be_retryable 5
    end
  end
end
