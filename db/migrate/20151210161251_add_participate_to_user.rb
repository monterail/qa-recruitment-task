class AddParticipateToUser < ActiveRecord::Migration
  def change
    add_column :users, :participate, :boolean, default: true
  end
end
