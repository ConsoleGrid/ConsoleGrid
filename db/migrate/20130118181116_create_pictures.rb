class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :game
      t.references :user
      t.string :image_url

      t.timestamps
    end
    add_index :pictures, :game_id
    add_index :pictures, :user_id
  end
end
