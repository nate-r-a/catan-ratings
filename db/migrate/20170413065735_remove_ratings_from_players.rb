class RemoveRatingsFromPlayers < ActiveRecord::Migration[5.0]
  def change
    remove_column :players, :rating
  end
end
