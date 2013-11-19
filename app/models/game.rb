class Game < ActiveRecord::Base
  belongs_to :console
  has_many :pictures, :dependent => :destroy
  attr_accessible :name
  attr_accessible :name, :console_id, :duplicate, :as => :admin
  
  self.per_page = 30
  
  scope :duplicates, where(:duplicate => true)
  
  searchable do
    text :name
    boolean :duplicate
    integer :console_id
  end
  
  def self.easy_search(string, page, options={})
    options.reverse_merge! :console_id => nil, :per_page => Game.per_page
    search_output = Game.solr_search do
      fulltext Game.escape_solr_string(string)
      with :duplicate, false
      with :console_id, options[:console_id] unless options[:console_id].nil?
      paginate :page => page, :per_page => options[:per_page]
    end
    # Sort the results
    sl = string.length
    search_results = search_output.results
    return search_results.sort do |a,b|
      adist = (a.name.length - sl).abs
      bdist = (b.name.length - sl).abs
      adist <=> bdist
    end
  end
  
  def self.escape_solr_string(string)
    formatted = string.downcase.gsub /([\\\+\-\&\|\!\(\)\{\}\[\]\^\~\*\?\:\"\; ])/ do |specialchar|
      "\\" << specialchar
    end
    return formatted
  end
  
  def self.indices_for_string(string)
    Game.format_for_indexing(string).split(" ")
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
