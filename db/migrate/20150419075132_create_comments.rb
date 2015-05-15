class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body
      t.references :owner, index: true
      t.references :proposition, index: true

      t.timestamps null: false
    end
  end
end
