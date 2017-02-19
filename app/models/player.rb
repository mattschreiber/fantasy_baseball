class Player < ActiveRecord::Base
	has_and_belongs_to_many :positions
	has_many :mlbteam_battings, through: :battings, source: :mlbteam
	has_many :mlbteam_pitchings, through: :pitchings, source: :mlbteam
	has_many :battings
	has_many :pitchings
	has_one :player_ranking

	# return player hash to make responding to js and json requests simpler.
	# the search method will return a players array of player hashes 
	players = []
	player = {}

	def self.search(search, bat_pitch)
		if search.nil?
			search = ""
		end
		if bat_pitch.nil?
			bat_pitch = "true"
		end
		if bat_pitch == "true"
			includes(:battings, :player_ranking).where("battings.year = ? AND player_rankings.id IS NOT NULL", 2016).references(:battings)
		else
			includes(:pitchings, :player_ranking).where("pitchings.year = ? AND player_rankings.id IS NOT NULL", 2016).references(:pitchings)
		end
  	# Player.includes("last_name LIKE ? AND batter = ?", "%#{search}%", bat_pitch)
	end

	def age(bd)
		now = Time.now
		if bd.month < now.month
			age = age = now.year - bd.year
		else
			age = now.year - bd.year - 1
		end
	end

end
