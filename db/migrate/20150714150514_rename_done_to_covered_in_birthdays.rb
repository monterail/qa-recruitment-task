class RenameDoneToCoveredInBirthdays < ActiveRecord::Migration
  def change
    rename_column :birthdays, :done, :covered
  end
end
