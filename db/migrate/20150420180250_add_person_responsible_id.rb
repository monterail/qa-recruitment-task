class AddPersonResponsibleId < ActiveRecord::Migration
  def change
    add_column :users, :person_responsible_id, :integer
  end
end
