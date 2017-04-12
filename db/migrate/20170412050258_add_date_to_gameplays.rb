class AddDateToGameplays < ActiveRecord::Migration[5.0]
  def change
    add_column :gameplays, :date, :date
  end
end
