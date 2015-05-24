class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :voter, index: true
      t.references :proposition, index: true
      t.integer :amount, default: 0

      t.timestamps null: false
    end
  end
end
