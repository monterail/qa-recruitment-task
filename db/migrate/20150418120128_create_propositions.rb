class CreatePropositions < ActiveRecord::Migration
  def change
    create_table :propositions do |t|
      t.string :title, null: false
      t.text :description
      t.decimal :value
      t.boolean :chosen
      t.integer :owner_id

      t.timestamps null: false
    end
  end
end
