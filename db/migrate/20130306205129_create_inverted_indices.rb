class CreateInvertedIndices < ActiveRecord::Migration
  def change
    create_table :inverted_indices, :id => false do |t|
      t.string :word
      t.text :documents
    end
  end
end
