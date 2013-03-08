class CreateConsoles < ActiveRecord::Migration
  def change
    create_table :consoles do |t|
      t.string :name
      t.string :shortname

      t.timestamps
    end
  end
end
