class Player < ActiveRecord::Base
	has_and_belongs_to_many :positions
	has_many :mlbteam_battings, through: :battings, source: :mlbteam
	has_many :mlbteam_pitchings, through: :pitchings, source: :mlbteam
	has_many :battings
	has_many :pitchings
	has_one :player_ranking
	belongs_to :owner

	attr_reader :name

	# return player hash to make responding to js and json requests simpler.
	# the search method will return a players array of player hashes
	players = []
	player = {}

	def self.search(search, bat_pitch, year, available)
		if search.nil?
			search = ""
		end
		if bat_pitch.nil?
			bat_pitch = "true"
		end

		if bat_pitch == "true"
			if available == true
				includes(:battings, :player_ranking).where("last_name LIKE ? AND battings.year = ? AND avail = ?", "%#{search}%", year, available).references(:battings).order("player_rankings.espn")
			else
				includes(:battings, :player_ranking).where("last_name LIKE ? AND battings.year = ?", "%#{search}%", year).references(:battings).order("player_rankings.espn")
			end
		else
			if available == true
				includes(:pitchings, :player_ranking).where("last_name LIKE ? AND pitchings.year = ? AND avail = ?", "%#{search}%", year, available).references(:pitchings, :player_ranking).order("player_rankings.espn")
			else
				includes(:pitchings, :player_ranking).where("last_name LIKE ? AND pitchings.year = ?", "%#{search}%", year).references(:pitchings, :player_ranking).order("player_rankings.espn")
			end
		end
  	# Player.includes("last_name LIKE ? AND batter = ?", "%#{search}%", bat_pitch)
	end

	def self.compare_players(player_ids, is_batter, year)
		if is_batter == "true"
			includes(:battings, :player_ranking).where("year = ? AND players.id IN (?)", year, player_ids).references(:battings).order("player_rankings.espn")
		else
			includes(:pitchings, :player_ranking).where("year = ? AND players.id IN (?)", year, player_ids).references(:pitchings, :player_ranking).order("player_rankings.espn")
		end

	end

	def name
		"#{first_name} #{last_name}"
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
