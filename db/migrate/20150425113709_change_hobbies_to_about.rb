class ChangeHobbiesToAbout < ActiveRecord::Migration
  def change
    remove_column :users, :hobbies, :text
    add_column :users, :about, :text
  end
end
