class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :game
      t.references :picture
      t.references :user
      t.integer :value

      t.timestamps
    end
    add_index :votes, :game_id
    add_index :votes, :picture_id
    add_index :votes, :user_id
  end
end
