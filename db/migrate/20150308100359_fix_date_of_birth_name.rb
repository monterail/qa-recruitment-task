class FixDateOfBirthName < ActiveRecord::Migration
  def change
    rename_column :users, :dateOfBirth, :date_of_birth
  end
end
