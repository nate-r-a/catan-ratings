class AddPositionToGameplay < ActiveRecord::Migration[5.0]
  def change
    add_column :gameplays, :position, :integer
  end
end
