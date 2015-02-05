class Console < ActiveRecord::Base
  has_many :games
  attr_accessible :name, :shortname
  attr_accessible :name, :shortname, :as => :admin

  self.per_page = 30

  searchable do
    text :name
    text :shortname
  end

  def self.easy_search(string, options={})
    options.reverse_merge! :page => 1, :per_page => Console.per_page
    search_output = Console.solr_search do
      fulltext string
      paginate :page => options[:page], :per_page => options[:per_page]
    end
    search_output.results
  end

  def as_json(options={})
    default_options = {
      :only => [
        :id,
        :name,
        :shortname,
      ]
    }
    super(default_options.merge(options))
  end
end
