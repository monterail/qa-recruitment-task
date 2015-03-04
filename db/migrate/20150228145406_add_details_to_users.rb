class AddDetailsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dateOfBirth, :date
    add_column :users, :szama, :boolean
    add_column :users, :hobbies, :text, array: true, default: []
  end
end
