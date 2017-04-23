class AddGamesPlayedToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :games_played, :integer
  end
end
