require "rails_helper"

describe NotifyBeforeBirthdays do
  include DeliveryHelper

  # We need those bangs here, because we always need our e-mail to be sent to someone
  # and we don't do anything with those users before sending
  let!(:dawid) { User.create(email: "dawid@example.com", name: "dawid", sso_id: "23456789") }
  let!(:hodak) { User.create(email: "hodak@example.com", name: "hodak", sso_id: "23456790") }
  let!(:jakub) { User.create(email: "jakub@example.com", name: "jakub", sso_id: "23456791") }

  before(:each) do
    ActionMailer::Base.deliveries = []
  end

  context "birthday in a month" do
    let(:notify_date) { 30.days.from_now }

    before(:each) do
      dawid.update_attributes(
        birthday_month: notify_date.month,
        birthday_day: notify_date.day,
      )
    end

    it "sends email" do
      expect { described_class.new.call }.to deliver_emails(2)
    end

    it "doesn't send email to celebrant" do
      described_class.new.call
      ActionMailer::Base.deliveries.each do |mail|
        expect(mail.to).not_to include(dawid.email)
      end
    end

    it "sends email to all users except celebrant" do
      described_class.new.call
      notification = ActionMailer::Base.deliveries.flat_map(&:to)
      expect(notification).to include(hodak.email)
      expect(notification).to include(jakub.email)
    end

    it "doesn't send email if birthday is covered" do
      BirthdayGenerator.new.call
      birthday = dawid.next_birthday
      birthday.update_attributes(covered: true)
      expect { described_class.new.call }.to deliver_emails(0)
    end
  end

  it "sends emails when birthday is in the next year" do
    time_december = Time.zone.local(2015, 12, 15)
    Timecop.freeze(time_december) do
      notify_date = time_december + 30.days
      dawid.update_attributes(birthday_month: notify_date.month, birthday_day: notify_date.day)
      expect { described_class.new.call }.to deliver_emails(2)
    end
  end
end
