class CreateGameplays < ActiveRecord::Migration[5.0]
  def change
    create_table :gameplays do |t|
      t.integer :score
      t.timestamps
    end
  end
end
