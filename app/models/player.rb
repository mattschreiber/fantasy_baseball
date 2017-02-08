class Player < ActiveRecord::Base
	has_and_belongs_to_many :positions
	has_many :mlbteams, through: :batting
	has_many :battings
end
