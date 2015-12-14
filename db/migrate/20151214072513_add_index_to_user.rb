class AddIndexToUser < ActiveRecord::Migration
  def change
    add_index :users, :is_participating
  end
end
