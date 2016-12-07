class AddAssignedAtToBirthday < ActiveRecord::Migration
  def up
    add_column :birthdays, :assigned_at, :datetime

    update <<-SQL
      UPDATE birthdays SET assigned_at = created_at
    SQL
  end

  def down
    remove_column :birthdays, :assigned_at
  end
end
