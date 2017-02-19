class Position < ActiveRecord::Base
	has_and_belongs_to_many :players

	def self.search(position, last_name, year)
  	players = find_by("pos = ?", position).players.includes(:pitchings, :player_ranking, :battings).where("last_name LIKE ? AND pitchings.year = ? OR battings.year = ?", "%#{last_name}%", year, year).order("player_rankings.espn")
	end
end
