class Game < ActiveRecord::Base
  belongs_to :console
  has_many :pictures
  attr_accessible :name
  fuzzily_searchable :name
  
  def self.format_for_indexing(string)
    formatted = string.downcase.gsub(/[^a-z1-9 ]/,"")
    return formatted
  end
  
  def self.indices_for_string(string)
    Game.format_for_indexing(string).split(" ")
  end
    
  def self.search(string, strict=true)
    indices = Game.indices_for_string(string)
    matches = InvertedIndex.where("word IN (?)",indices)
    if strict and matches.count != indices.count
      # Return a query that matches nothing
      return Game.where("id in ()")
    end
    docs = nil
    matches.each do |iindex|
      if docs.nil?
        docs = iindex.document_ids
      else
        docs = docs & iindex.document_ids
      end
    end
    Game.where("id IN (?)",docs)
  end  
    
  def populate_inverted_index
    indices = self.class.indices_for_string(self.name)
    indices.each do |index|
      invindex = InvertedIndex.find_or_create_by_word(index)
      doc_ids = invindex.document_ids
      doc_ids.push(self.id)
      invindex.document_ids = doc_ids.push(self.id)
      invindex.save
    end
  end  
  
  def top_rated_picture
    self.pictures.find_with_reputation(:votes, :all, :order => "votes desc", :limit => 1).first
  end
end
