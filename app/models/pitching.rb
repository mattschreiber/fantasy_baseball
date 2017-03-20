class Pitching < ActiveRecord::Base
	include TeamProjection
	include PlayerProjection

  belongs_to :player
  belongs_to :mlbteam
end
