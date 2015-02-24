class CreateHellos < ActiveRecord::Migration
  def change
    create_table :hellos do |t|
      t.string :language
      t.string :greeting

      t.timestamps
    end
  end
end
