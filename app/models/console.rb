class Console < ActiveRecord::Base
  has_many :games
  attr_accessible :name, :shortname
end
