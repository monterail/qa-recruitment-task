class CreatePersonResponsibles < ActiveRecord::Migration
  def change
    create_table :person_responsibles do |t|
      t.references :celebrant, index: true
      t.references :person_responsible, index: true
      t.integer :year

      t.timestamps null: false
    end
  end
end
