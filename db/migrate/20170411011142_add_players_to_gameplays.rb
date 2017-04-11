class AddPlayersToGameplays < ActiveRecord::Migration[5.0]
  def change
    add_reference :gameplays, :player, foreign_key: true
  end
end
