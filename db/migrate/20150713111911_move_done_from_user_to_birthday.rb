class MoveDoneFromUserToBirthday < ActiveRecord::Migration
  def change
    remove_column :users, :done, :boolean
    add_column :birthdays, :done, :boolean, default: false
  end
end
