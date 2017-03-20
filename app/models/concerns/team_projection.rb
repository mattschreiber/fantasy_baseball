module TeamProjection
  extend ActiveSupport::Concern

  module ClassMethods

  	def team_totals(year, owner_id, batter)
  	#calculates a teams totals for each category with starter = true
    starter_weight = 0 # if pitcher is a starter they should count
  	players = self.joins(player: :owner).where("year = ? AND players.owner_id = ? AND players.starter = true", year, owner_id)
  	total = Hash.new(0)
	  	if batter == true
		  	players.each do |batter|
		  		bat = batter.slice("runs", "hr", "rbi", "sb", "average")
		  		bat.each do |k, v|
		  			total[k] += v
		  		end
		  	end
		  	total["average"] = total["average"] / players.count unless players.count == 0
			else
				players.each do |pitcher|
					pitch = pitcher.slice("wins", "sv", "so", "era", "whip")
					pitch.each do |k, v|
            if pitcher.player.positions[0].pos == "SP" and (k == "era" or k == "whip")
		  			       total[k] += (v * 2.5)
                  #  Espn projections didn't include innings or earned runs so I'm estimating
                  # that a starter will throw on average 2.5 more innings then a reliever
                  # The .75 is because each SP will loop through 2x (1 for era and 1 for whip thus totaling 1.5 plus each player
                  # is already counted 1x in the player.count)
                   starter_weight += 0.75
            else
              total[k] += v
            end
		  		end
		  	end
		  	total["era"] = total["era"] / (players.count + starter_weight) unless players.count == 0
		  	total["whip"] = total["whip"] / (players.count + starter_weight) unless players.count == 0
			end
      # total["owner_id"] = owner_id
	  	return total.symbolize_keys
  	end

    def team_player_stats (year, owner_id, batter)
    	joins(player: [:owner,:positions]).where("year = ? AND players.owner_id = ?", year, owner_id).order('positions.sort')
    end

    # returns hash with player_id and total points based on rankings in each categories
    def category_compare(params)
      player_totals = Hash.new(0)
      player_array = []
      year = params[:year] || Time.now.year
      # check params hash for any params that include category as key
      categories = []
      weights = []
      params.each do |k,v|
        if /^category(.*)/.match(k)
          categories << v
        end
        if /^num(.*)/.match(k)
          if !v.blank?
            weights << v
          else
            weights << 1 #set weight to 1 if no weight found in params
          end
        end
      end #end search for categories in params hash
      i = 0 # iterator to apply appropriate weight to each category
      categories.each do |category|
          temp_hash = {}
          player_hash = {}
          if category == 'era' || category == 'whip'
            temp_hash = self.joins(:player).where('year = ? AND players.avail = ?', year, true).order("#{category}": :asc).pluck(:player_id, :"#{category}").sort_by{|k,v| v}.to_h
          else
            temp_hash = self.joins(:player).where('year = ? AND players.avail = ?', year, true).order("#{category}": :desc).pluck(:player_id, :"#{category}").sort_by{|k,v| v}.reverse.to_h
          end #sort hash for ranking descending unless era or whip since lower is better for these 2 categories
          player_hash = TeamSeason.rankv2(temp_hash)
          player_hash.each {|k,v| player_hash[k] = v * weights[i]}
          player_totals.merge!(player_hash){|k, oldval, newval| oldval + newval}
          i += 1
      end #end categories loop
      return player_totals
    end #end category_compare method
  end # end of ClassMethods
end # end of module TeamProjection
