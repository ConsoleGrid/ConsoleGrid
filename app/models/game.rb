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
    return search_output.results
  end
  
  def self.escape_solr_string(string)
    formatted = string.downcase.gsub /([\\\+\-\&\|\!\(\)\{\}\[\]\^\~\*\?\:\"\; ])/ do |specialchar|
      "\\" << specialchar
    end
    return formatted
  end

  def top_rated_picture
    self.pictures.find_with_reputation(:votes, :all, :order => "votes desc", :limit => 1).first
  end
end
