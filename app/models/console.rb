class Console < ActiveRecord::Base
  has_many :games
  attr_accessible :name, :shortname
  attr_accessible :name, :shortname, :as => :admin
end
