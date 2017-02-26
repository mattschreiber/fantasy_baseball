module TeamProjection
  extend ActiveSupport::Concern

  module ClassMethods

  	def team_totals(year, owner_id, batter)
  	#calculates a teams totals for each category
  	players = self.joins(player: :owner).where("year = ? AND players.owner_id = ?", year, owner_id).as_json
  	total = Hash.new(0)
	  	if batter == true
		  	players.each do |batter|
		  		batter.slice!("runs", "hr", "rbi", "sb", "average")
		  		batter.each do |k, v|
		  			total[k] += v
		  		end
		  	end
		  	total["average"] = total["average"] / players.count
			else
				players.each do |pitcher|
					pitcher.slice!("wins", "sv", "so", "era", "whip")
					pitcher.each do |k, v|
		  			total[k] += v
		  		end
		  	end
		  	total["era"] = total["era"] / players.count
		  	total["whip"] = total["whip"] / players.count
			end
	  	return total.symbolize_keys
  	end

  def team_player_stats (year, owner_id, batter)
  	joins(player: :owner).where("year = ? AND players.owner_id = ?", year, owner_id)
  end

  end
end