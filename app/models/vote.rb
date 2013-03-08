class Vote < ActiveRecord::Base
  belongs_to :game
  belongs_to :picture
  belongs_to :user
  attr_accessible :value
end
