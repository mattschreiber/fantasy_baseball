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
		if params[:is_batter] == 'true'
			hash = Batting.category_compare(params)
			players_rank = hash.first(10).to_h
			players = Player.joins(:player_ranking, :positions, battings: :mlbteam).where('battings.year = ? AND players.id IN (?)',year, players_rank.keys).order('players.id').pluck('players.first_name,
				players.last_name, players.birthday, positions.pos, mlbteams.abbr, battings.runs, battings.hr, battings.rbi, battings.sb, battings.average, battings.wrc')
		else
			hash = Pitching.category_compare(params)
			players_rank = hash.first(10).to_h
			players = Player.joins(:player_ranking, :positions, pitchings: :mlbteam).where('pitchings.year = ? AND players.id IN (?)',year, players_rank.keys).order('players.id').order('players.id').pluck('players.first_name,
				players.last_name, players.birthday, positions.pos, mlbteams.abbr, pitchings.wins, pitchings.so, pitchings.era, pitchings.whip, pitchings.sv')
		end #if/else is_batter
		result = []
		players_rank = players_rank.sort_by{|k, v| k}.to_h
		i = 0
		players.each do |player|
		 	player << players_rank.values[i] #add players rank to player
			result << player #player with rank to new result
			i += 1
		end
		p = Player.new
		# convert result array into hash before and then return sorted hash by most ranking points
		p.convert_to_hash(result)
		return p.sort_by {|k, v| k[:rank_points]}.reverse
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

	def convert_to_hash(arrays)
		result = []
		keys = :first_name, :last_name, :birthday, :pos, :mlbteam, :runs, :hr, :rbi, :sb, :average, :wrc, :rank_points
		arrays.each do |array|
			hash = {}
			array.each.with_index do |a, i|
				hash[keys[i]] = a
			end #end inner array loop
			result << hash
		end #end outer array loop
		return result
	end # end convert_to_hash
end
#params = {category: 'hr', num: 1, is_batter: 'true'}
#players = Player.player_rank(params)
