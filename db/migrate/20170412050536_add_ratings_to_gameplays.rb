class AddRatingsToGameplays < ActiveRecord::Migration[5.0]
  def change
    add_column :gameplays, :before, :decimal
    add_column :gameplays, :after, :decimal
  end
end
