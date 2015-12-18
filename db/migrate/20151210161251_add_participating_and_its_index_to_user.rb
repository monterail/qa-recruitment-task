class AddParticipatingAndItsIndexToUser < ActiveRecord::Migration
  def change
    add_column :users, :participating, :boolean, default: true
    add_index :users, :participating
  end
end
