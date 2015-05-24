class ChangeVoterToUser < ActiveRecord::Migration
  def change
    rename_column :votes, :voter_id, :user_id
  end
end
