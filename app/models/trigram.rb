class Trigram < ActiveRecord::Base
  attr_accessible :trigram, :score, :owner_type
  include Fuzzily::Model
end
