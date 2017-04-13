class ChangeScoreToFloat < ActiveRecord::Migration[5.0]
  def change
    change_column :gameplays, :score, :float
  end
end
