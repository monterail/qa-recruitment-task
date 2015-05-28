class RenamePersonResponsibleToBirthday < ActiveRecord::Migration
  def change
    rename_table :person_responsibles, :birthdays
  end
end
