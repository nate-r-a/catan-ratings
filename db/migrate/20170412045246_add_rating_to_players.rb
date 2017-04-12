class AddRatingToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :rating, :decimal
  end
end
