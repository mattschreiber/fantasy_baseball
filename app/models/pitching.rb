class Pitching < ActiveRecord::Base
	include TeamProjection
	
  belongs_to :player
  belongs_to :mlbteam
end
