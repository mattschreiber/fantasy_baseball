class Mlbteam < ActiveRecord::Base
	has_many :players, through: :batting
	has_many :players, through: :pitching
end
