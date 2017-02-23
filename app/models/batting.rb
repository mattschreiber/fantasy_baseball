class Batting < ActiveRecord::Base
  belongs_to :player
  belongs_to :mlbteam

  def self.team_totals(year, owner_id)
  	#calculates a teams totals for each category
  	batters = self.joins(player: :owner).where("year = ? AND players.owner_id = ?", year, owner_id).as_json
  	total = Hash.new(0)
  	batters.each do |batter|
  		batter.slice!("runs", "hr", "rbi", "sb", "average")
  		batter.each do |k, v|
  			total[k] += v
  		end
  	end
  	total["average"] = total["average"] / batters.count
  	return total
  end

end
