require "rails_helper"

describe NotifyUserResponsibleWorker do
  include DeliveryHelper

  let!(:celebrant) do
    User.create(email: "celebrant@example.com", name: "celebrant", sso_id: "1")
  end
  let!(:person_responsible) do
    User.create(email: "person_responsible@example.com", name: "person_responsible", sso_id: "2")
  end
  let!(:user_second) do
    User.create(email: "user_second@example.com", name: "user_second", sso_id: "3")
  end

  context "notify about responsibility" do
    subject { described_class.perform_async(person_responsible.id, celebrant.id) }

    before do
      ActionMailer::Base.deliveries = []
      subject
    end

    it "send one email" do
      expect(ActionMailer::Base.deliveries.count).to eql(1)
    end

    it "send email with proper subject" do
      expect(ActionMailer::Base.deliveries.first.subject).to eql("You have been chosen!")
    end

    it "send email only to person responsible" do
      emails = ActionMailer::Base.deliveries.flat_map(&:to)
      expect(emails).to match_array(person_responsible.email)
    end

    it "is retryable for 3 times" do
      expect(described_class).to be_retryable 3
    end
  end
end
