class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :name
      t.references :gameplay, foreign_key: true

      t.timestamps
    end
  end
end
