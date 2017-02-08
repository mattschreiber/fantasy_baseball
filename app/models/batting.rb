class Batting < ActiveRecord::Base
  belongs_to :player
  belongs_to :mlbteam
end
