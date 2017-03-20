class Player < ActiveRecord::Base
	has_and_belongs_to_many :positions
	has_many :mlbteam_battings, through: :battings, source: :mlbteam
	has_many :mlbteam_pitchings, through: :pitchings, source: :mlbteam
	has_many :battings
	has_many :pitchings
	has_many :notes, dependent: :destroy
	has_one :player_ranking
	belongs_to :owner

	accepts_nested_attributes_for :notes, allow_destroy: true

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
	end # end search

	def self.compare_players(player_ids, is_batter, year)
		if is_batter == "true"
			includes(:battings, :player_ranking).where("year = ? AND players.id IN (?)", year, player_ids).references(:battings).order("player_rankings.espn")
		else
			includes(:pitchings, :player_ranking).where("year = ? AND players.id IN (?)", year, player_ids).references(:pitchings, :player_ranking).order("player_rankings.espn")
		end
	end #end compare_players

	def self.player_rank(params)
		# limit results to top 10 highest combined rank points
		year = params[:year] || Time.now.year
		hash = {}
		result = []
		if params[:is_batter] == 'true'
			hash = Batting.category_compare(params)
			players_rank = hash.first(10).to_h
			players = Player.joins(:battings, :player_ranking).where('battings.year = ? AND players.id IN (?)',year, players_rank.keys).order('players.id').map { |player| player.attributes.symbolize_keys}
		else
			hash = Pitching.category_compare(params)
			players_rank = hash.first(10).to_h
			players = Player.joins(:pitchings, :player_ranking).where('pitchings.year = ? AND players.id IN (?)',year, players_rank.keys).order('players.id').map { |player| player.attributes.symbolize_keys}
		end #if/else is_batter
		players_rank = players_rank.to_a.sort #player_id in position 0 and rank_points in position 1 of array
		i = 0
		players.each do |player|
			player[:rank_points] = players_rank[i][1]
			i += 1
		end
		return players.sort_by {|k, v| k[:rank_points]}.reverse
	end #end calc_player_rank

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
