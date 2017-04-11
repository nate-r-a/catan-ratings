class AddGameToGameplays < ActiveRecord::Migration[5.0]
  def change
    add_reference :gameplays, :game, foreign_key: true
  end
end
