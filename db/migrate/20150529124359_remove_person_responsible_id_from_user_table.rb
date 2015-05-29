class RemovePersonResponsibleIdFromUserTable < ActiveRecord::Migration
  def change
    remove_column :users, :person_responsible_id, :integer
  end
end
