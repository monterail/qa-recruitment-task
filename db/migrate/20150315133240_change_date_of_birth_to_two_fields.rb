class ChangeDateOfBirthToTwoFields < ActiveRecord::Migration
  def change
    add_column :users, :birthday_month, :integer
    add_column :users, :birthday_day, :integer
    remove_column :users, :date_of_birth
  end
end
