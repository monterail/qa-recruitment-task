require "rails_helper"

describe NotifyAboutGiftsWorker do
  include DeliveryHelper

  let!(:dawid) { User.create(email: "dawid@example.com", name: "dawid", sso_id: "23456789") }
  let!(:hodak) { User.create(email: "hodak@example.com", name: "hodak", sso_id: "23456790") }
  let!(:jakub) { User.create(email: "jakub@example.com", name: "jakub", sso_id: "23456791") }

  context "notify about gifts" do
    let(:subject) { "Test subject" }
    let(:content) { "Test content" }

    let!(:emails) do
      ActionMailer::Base.deliveries = []
      described_class.perform_async(dawid.id, subject, content)
      ActionMailer::Base.deliveries.flat_map(&:to)
        .concat(ActionMailer::Base.deliveries.flat_map(&:bcc))
    end

    it "send one email" do
      expect(ActionMailer::Base.deliveries.count).to eql(1)
    end

    it "doesn't send email to celebrant" do
      expect(emails).not_to include(dawid.email)
    end

    it "sends email to all users except celebrant" do
      expect(emails).to include(hodak.email).and include(jakub.email)
    end

    it "is retryable for 5 times" do
      expect(described_class).to be_retryable 5
    end
  end
end
