class ChangeRatingsOnGameplays < ActiveRecord::Migration[5.0]
  def change
    change_column :gameplays, :after, :float
    change_column :gameplays, :before, :float

  end
end
