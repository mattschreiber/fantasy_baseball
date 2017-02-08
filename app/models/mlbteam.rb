class Mlbteam < ActiveRecord::Base
	has_many :players, through: :batting
end
