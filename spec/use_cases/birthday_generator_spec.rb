require "rails_helper"

describe BirthdayGenerator do
  # We always need at least 2 people so we have an option to create a birthday
  let!(:dawid) { User.create(email: "dawid@example.com", name: "dawid", sso_id: "23456789") }
  let!(:hodak) { User.create(email: "hodak@example.com", name: "hodak", sso_id: "23456790") }
  let(:jakub) { User.create(email: "jakub@example.com", name: "jakub", sso_id: "23456791") }

  describe "celebrants are chosen from next 3 months" do
    after(:each) do
      Timecop.return
    end

    it "current month but after today" do
      dawid.update_attributes(birthday_month: 2, birthday_day: 20)
      time_febraury = Time.zone.local(Time.zone.today.year, 2, 1, 16, 37, 0)
      Timecop.freeze(time_febraury)
      expect { described_class.new.call }.to change { Birthday.count }.by(1)
    end

    it "1 month from now" do
      dawid.update_attributes(
        birthday_month: 1.month.from_now.month,
        birthday_day: 1,
      )
      expect { described_class.new.call }.to change { Birthday.count }.by(1)
    end

    it "3 month from now" do
      dawid.update_attributes(
        birthday_month: 3.month.from_now.month,
        birthday_day: 1,
      )
      expect { described_class.new.call }.to change { Birthday.count }.by(1)
    end

    it "1 month ago" do
      dawid.update_attributes(
        birthday_month: 1.month.ago.month,
        birthday_day: 1,
      )
      expect { described_class.new.call }.to change { Birthday.count }.by(0)
    end

    it "current month but before today" do
      dawid.update_attributes(
        birthday_month: 2,
        birthday_day: 2,
      )
      time_febraury = Time.zone.local(Time.zone.today.year, 2, 4, 16, 37, 0)
      Timecop.freeze(time_febraury)
      expect { described_class.new.call }.to change { Birthday.count }.by(0)
    end

    it "4 months from now" do
      dawid.update_attributes(
        birthday_month: 4.month.from_now.month,
        birthday_day: 1,
      )
      expect { described_class.new.call }.to change { Birthday.count }.by(0)
    end

    it "2 months from now, but next year" do
      dawid.update_attributes(
        birthday_month: 1,
        birthday_day: 2,
      )
      time_november = Time.zone.local(Time.zone.today.year, 11, 4, 16, 37, 0)
      Timecop.freeze(time_november)
      expect { described_class.new.call }.to change { Birthday.count }.by(1)
    end
  end

  it "doesn't create new birthday if there is already a birthday for this celebrant" do
    dawid.update_attributes(
      birthday_month: 1.month.from_now.month,
      birthday_day: 1,
    )
    expect { described_class.new.call }.to change { Birthday.count }.by(1)
    expect { described_class.new.call }.to change { Birthday.count }.by(0)
  end

  it "creates 2 Birthdays when there are 2 free celebrants" do
    dawid.update_attributes(
      birthday_month: 1.month.from_now.month,
      birthday_day: 1,
    )
    hodak.update_attributes(birthday_month: 2.month.from_now.month,
                            birthday_day: 1,
                           )
    expect { described_class.new.call }.to change { Birthday.count }.by(2)
  end

  it "assigns a person responsible even when every possible
      person responsible took care of some birthday already" do
    dawid.update_attributes(
      birthday_month: 1.month.from_now.month,
      birthday_day: 1,
    )
    hodak.update_attributes(
      birthday_month: 2.month.from_now.month,
      birthday_day: 1,
    )
    jakub.update_attributes(
      birthday_month: 2.month.from_now.month,
      birthday_day: 14,
    )
    Birthday.create(
      celebrant: dawid,
      person_responsible: hodak,
      year: Time.zone.today.year,
    )
    Birthday.create(
      celebrant: hodak,
      person_responsible: dawid,
      year: Time.zone.today.year,
    )
    described_class.new.call
    birthday = Birthday.find_by!(celebrant_id: jakub.id, year: Time.zone.today.year)
    expect(birthday.year).to eq(Time.zone.today.year)
  end

  describe "person responsible when choosing, has the least
            birhtdays as person responsible in the last year" do
    context "had couple birthdays long time ago" do
      before(:each) do
        dawid.update_attributes(
          birthday_month: 1.month.from_now.month,
          birthday_day: 1,
        )
        hodak.update_attributes(
          birthday_month: 2.month.from_now.month,
          birthday_day: 1,
        )
      end

      it "assigns person_responsible_that_had_birthday_long_time_ago" do
        Birthday.create(
          celebrant: dawid,
          person_responsible: hodak,
          year: Time.zone.today.year,
          created_at: 2.years.ago,
        )
        Birthday.create(
          celebrant: dawid,
          person_responsible: hodak,
          year: Time.zone.today.year,
          created_at: 3.years.ago,
        )
        Timecop.return
        Birthday.create(
          celebrant: hodak,
          person_responsible: jakub,
          year: Time.zone.today.year,
        )
        described_class.new.call
        birthday = Birthday.find_by!(celebrant_id: dawid.id, year: Time.zone.today.year)
        expect(birthday.person_responsible.id).to eq(hodak.id)
      end
    end

    context "had no birthdays yet" do
      it "assigns person responsible that had no birthdays yet" do
        dawid.update_attributes(
          birthday_month: 1.month.from_now.month,
          birthday_day: 1,
        )
        hodak.update_attributes(
          birthday_month: 2.month.from_now.month,
          birthday_day: 1,
        )
        Birthday.create(
          celebrant: dawid,
          person_responsible: jakub,
          year: Time.zone.today.year,
        )
        Birthday.create(
          celebrant: dawid,
          person_responsible: jakub,
          year: Time.zone.today.year - 1,
        )
        described_class.new.call
        birthday = Birthday.find_by(celebrant_id: hodak.id, year: Time.zone.today.year)
        expect(birthday.person_responsible.id).to eq(dawid.id)
      end
    end
  end
end
