class Mlbteam < ActiveRecord::Base
	has_many :batter_teams, through: :battings, source: :player
	has_many :pitcher_teams, through: :pitchings, source: :player
	has_many :battings
	has_many :pitchings
end
