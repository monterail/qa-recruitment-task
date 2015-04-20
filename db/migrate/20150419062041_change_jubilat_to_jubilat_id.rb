class ChangeJubilatToJubilatId < ActiveRecord::Migration
  def change
    rename_column :propositions, :jubilat, :jubilat_id
  end
end
