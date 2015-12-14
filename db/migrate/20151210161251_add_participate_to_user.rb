class AddParticipateToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_participating, :boolean, default: true
  end
end
