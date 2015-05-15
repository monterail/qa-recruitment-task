class ChangeJubilatToCelebrant < ActiveRecord::Migration
  def change
    rename_column :propositions, :jubilat_id, :celebrant_id
  end
end
