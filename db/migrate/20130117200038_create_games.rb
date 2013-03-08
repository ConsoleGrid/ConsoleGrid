class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.references :console
      t.string :name

      t.timestamps
    end
    add_index :games, :console_id
  end
end
