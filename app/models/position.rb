class Position < ActiveRecord::Base
	has_and_belongs_to_many :players

	def self.search(position, last_name, year, bat_pitch, available)
		if bat_pitch == "true"
			if available == true
  			players = find_by("pos = ?", position.upcase).players.includes(:player_ranking, :battings).where("last_name LIKE ? AND battings.year = ? AND avail = ?", "%#{last_name}%", year, available).order("player_rankings.espn")
  		else
  			players = find_by("pos = ?", position.upcase).players.includes(:player_ranking, :battings).where("last_name LIKE ? AND battings.year = ?", "%#{last_name}%", year).order("player_rankings.espn")
  		end
  	else
  		if available == true
  			players = find_by("pos = ?", position.upcase).players.includes(:player_ranking, :pitchings).where("last_name LIKE ? AND pitchings.year = ? AND avail = ?", "%#{last_name}%", year, available).order("player_rankings.espn")
  		else
  			players = find_by("pos = ?", position.upcase).players.includes(:player_ranking, :pitchings).where("last_name LIKE ? AND pitchings.year = ?", "%#{last_name}%", year).order("player_rankings.espn")
  		end			
  	end
	end
end
