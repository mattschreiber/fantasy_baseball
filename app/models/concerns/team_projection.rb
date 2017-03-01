module TeamProjection
  extend ActiveSupport::Concern

  module ClassMethods

  	def team_totals(year, owner_id, batter)
  	#calculates a teams totals for each category with starter = true
  	players = self.joins(player: :owner).where("year = ? AND players.owner_id = ? AND players.starter = true", year, owner_id).as_json
  	total = Hash.new(0)
	  	if batter == true
		  	players.each do |batter|
		  		batter.slice!("runs", "hr", "rbi", "sb", "average")
		  		batter.each do |k, v|
		  			total[k] += v
		  		end
		  	end
		  	total["average"] = total["average"] / players.count unless players.count == 0
			else
				players.each do |pitcher|
					pitcher.slice!("wins", "sv", "so", "era", "whip")
					pitcher.each do |k, v|
		  			total[k] += v
		  		end
		  	end
		  	total["era"] = total["era"] / players.count unless players.count == 0
		  	total["whip"] = total["whip"] / players.count unless players.count == 0
			end
	  	return total.symbolize_keys
  	end

  def team_player_stats (year, owner_id, batter)
  	joins(player: :owner, player: :positions).where("year = ? AND players.owner_id = ?", year, owner_id).order('positions.pos')
  end

  end
end