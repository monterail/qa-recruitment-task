class AddJubilatToProposition < ActiveRecord::Migration
  def change
    add_column :propositions, :jubilat, :integer
  end
end
