class RemoveGameplaysFromPlayers < ActiveRecord::Migration[5.0]
  def change
    remove_reference :players, :gameplay, foreign_key: true
  end
end
