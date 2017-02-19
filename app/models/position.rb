class Position < ActiveRecord::Base
	has_and_belongs_to_many :players

	def self.search(position, last_name)
  	players = find_by("pos = ?", position).players.includes(:pitchings, :player_ranking).where("last_name LIKE ?", "%#{last_name}%")
	end
end
