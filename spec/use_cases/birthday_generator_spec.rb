require "rails_helper"

describe BirthdayGenerator do
  let!(:user_first) do
    User.create(email: "user_first@example.com", name: "user_first", sso_id: "23456789")
  end
  let!(:user_second) do
    User.create(email: "user_second@example.com", name: "user_second", sso_id: "23456790")
  end

  describe "#call" do
    after(:each) do
      Timecop.return
    end

    context "celebrants are chosen from next 3 months" do
      it "current month but after today" do
        user_first.update_attributes(birthday_month: 2, birthday_day: 20)
        time_february = Time.zone.local(Time.zone.today.year, 2, 1, 16, 37, 0)
        Timecop.freeze(time_february)
        expect { described_class.new.call }.to change { Birthday.count }.by(1)
      end

      it "1 month from now" do
        user_first.update_attributes(
          birthday_month: 1.month.from_now.month,
          birthday_day: 1,
        )
        expect { described_class.new.call }.to change { Birthday.count }.by(1)
      end

      it "3 month from now" do
        user_first.update_attributes(
          birthday_month: 3.month.from_now.month,
          birthday_day: 1,
        )
        expect { described_class.new.call }.to change { Birthday.count }.by(1)
      end

      it "1 month ago" do
        user_first.update_attributes(
          birthday_month: 1.month.ago.month,
          birthday_day: 1,
        )
        expect { described_class.new.call }.to change { Birthday.count }.by(0)
      end

      it "current month but before today" do
        user_first.update_attributes(
          birthday_month: 2,
          birthday_day: 2,
        )
        time_february = Time.zone.local(Time.zone.today.year, 2, 4, 16, 37, 0)
        Timecop.freeze(time_february)
        expect { described_class.new.call }.to change { Birthday.count }.by(0)
      end

      it "4 months from now" do
        user_first.update_attributes(
          birthday_month: 4.month.from_now.month,
          birthday_day: 1,
        )
        expect { described_class.new.call }.to change { Birthday.count }.by(0)
      end

      it "2 months from now, but next year" do
        user_first.update_attributes(
          birthday_month: 1,
          birthday_day: 2,
        )
        time_november = Time.zone.local(Time.zone.today.year, 11, 4, 16, 37, 0)
        Timecop.freeze(time_november)
        expect { described_class.new.call }.to change { Birthday.count }.by(1)
      end

      it "doesn't create new birthday if there is already a birthday for this celebrant" do
        user_first.update_attributes(
          birthday_month: 1.month.from_now.month,
          birthday_day: 1,
        )
        expect { described_class.new.call }.to change { Birthday.count }.by(1)
        expect { described_class.new.call }.to change { Birthday.count }.by(0)
      end

      it "creates 2 Birthdays when there are 2 free celebrants" do
        user_first.update_attributes(
          birthday_month: 1.month.from_now.month,
          birthday_day: 1,
        )
        user_second.update_attributes(
          birthday_month: 2.month.from_now.month,
          birthday_day: 1,
        )
        expect { described_class.new.call }.to change { Birthday.count }.by(2)
      end
    end

    context "assign person responsible" do
      let(:last_person_responsible_id) { Birthday.last.person_responsible_id }

      subject { described_class.new.call }

      context "when there are only 2 users" do
        before do
          user_first.update_attributes(
            birthday_month: 1.month.from_now.month,
            birthday_day: 1,
          )
        end

        it "assing second user to person responsible" do
          subject
          expect(last_person_responsible_id).to eq user_second.id
        end

        it "assing first user to person responsible" do
          user_second.update_attributes(
            birthday_month: 1.month.from_now.month,
            birthday_day: 2,
          )
          subject
          expect(last_person_responsible_id).to eq user_first.id
        end
      end

      context "when there are more users" do
        let(:limit) { User::RESPONSIBLE_USERS_LIMIT }
        before do
          1..limit.times do |item|
            User.create(
              email: "user+#{item}@example.com", name: "user+#{item}", sso_id: "#{item}",
              birthday_month: 1.month.from_now.month, birthday_day: 2 + item
            )
          end
          user_first.update_attributes(
            birthday_month: Time.zone.now.month,
            birthday_day: 1,
          )
          Birthday.create(
            celebrant: user_first,
            person_responsible: user_second,
            year: Time.zone.today.year,
            assigned_at: Time.zone.yesterday,
          )
          subject
        end

        it "second user shouldn't be assign by next 15 birthdays" do
          expect(Birthday.last(limit).map(&:person_responsible_id)).not_to include user_second.id
        end

        context "when user should be assign after 15 birthdays" do
          before do
            User.create(
              email: "usesr_third@example.com", name: "user_third", sso_id: "23416791",
              birthday_month: 1.month.from_now.month, birthday_day: 20
            )
          end

          it { expect { described_class.new.call }.to change { Birthday.count }.by(1) }

          it "assign next user" do
            last_persons_responsible = Birthday.last(limit).map(&:person_responsible_id)
            described_class.new.call
            expect(last_persons_responsible).not_to include last_person_responsible_id
          end
        end
      end
    end
  end
end
