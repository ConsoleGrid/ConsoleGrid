class AddDuplicateToGames < ActiveRecord::Migration
  def change
    add_column :games, :duplicate, :boolean, :default => 0
  end
end
