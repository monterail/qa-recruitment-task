class ChangeChosenToChosenYear < ActiveRecord::Migration
  def change
    remove_column :propositions, :chosen, :boolean
    add_column :propositions, :year_chosen_in, :integer
  end
end
