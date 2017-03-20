namespace :csv do
	desc "Update batters assigned to each owner"
	task :owner_batter => :environment do
		csv_import('lib/csv_files/o_p.csv')
	end
	desc "Update pitchers assigned to each owner"
	task :owner_pitcher => :environment do
		csv_import('lib/csv_files/o_pitcher.csv')
	end

	task :all => [:owner_batter, :owner_pitcher]

	def csv_import(filename)
		doc = CSV.read(filename)
		doc.each do |r|
			play = Player.where(first_name: r[1], last_name: r[2]).first
			if !play.nil?
				o = Owner.where(abbr: r[5]).first
				if !o.nil?
					play.update(avail: false, owner_id: o.id)
				end
			end
		end
	end

	desc "Search Google for latest espn rankings"
	task :download_espn_rank => :environment do
		a = Mechanize.new
		search_result = []
		# search google for Espn Top 300
		a.get('http://google.com/') do |page|
  		search_result = page.form_with(:name => 'f') do |search|
    		search.q = 'Espn Fantasy Baseball Top 300'
  		end.submit
		end
		# We want the first link that matches both espn and roto rankings
		pr = search_result.links_with(:href => /.*?espn.*?rankingsroto/).first.click
		arr = []
		pr.parser.css('.last').each do |rk|
			arr << rk.css("td")[0].text.split
		end
 		CSV.open("lib/csv_files/espn_rk.csv", "w+") do |csv|
 			until arr.empty?
 				csv << arr.shift
 			end
 		end
	end #end task Search Google for lastest espn rankings

	desc "update espn rankings"
	task :espn_rank => :environment do
		new_rank = []
		exist = []
		doc = CSV.read('lib/csv_files/espn_rk.csv')
		PlayerRanking.update_all(espn: nil)
		doc[0..300].each do |r|
			#search for player (assumes first_name in second column and last_name is 3rd col)
			play = Player.where(first_name: r[1], last_name: r[2]).first
			if !play.nil?
				if PlayerRanking.find_by(player_id: play.id)
					PlayerRanking.find_by(player_id: play.id).update(espn: r[0])
				else
					PlayerRanking.create(player_id: play.id, espn: r[0])
					new_rank << "Created new player ranking: #{r[1]} #{r[2]}"
				end
			else
				#if the player isn't found print to console so can create new player
				exist << "Player doesn't exist: #{r[1]} #{r[2]} #{r[0]}"
			end
		end
		#print list of people who are new are rankings
		new_rank.each do |r|
			puts r
		end
		#print list of people who aren't in db
		exist.each do |r|
			puts r
		end
	end

	task :espn => [:download_espn_rank, :espn_rank]

	# desc "FanGraphs Stats"
	# task :fangraphs => :environment do
	# 		year = 2017
	# 		s_weight = 0.3 #weight to be applied to FanGraphs statistics
	# 		e_weight = 0.7  #weight for espn stats
	#
	# 		player_exist = [] #gather list of players who aren't in db
	# 		bat_year_exist = [] #gather list of players with no batting records in db
	# 		fg = CSV.read('lib/csv_files/FanGraphsLeaderboard.csv', {headers: true, header_converters: :symbol})
	# 		fg.each do |row|
	# 			player = Player.where(first_name: row[:name].split[0], last_name: row[:name].split[1]).first
	# 			if !player.nil?
	# 				bat = Batting.where(player_id: player[:id], year: year).first
	# 				if !bat.nil?
	# 					steamer = row.to_h.slice(:r, :hr, :rbi, :sb, :avg)
	# 					steamer_weighted = steamer.values.map{|m| m.to_f * s_weight}
	#
	# 					espn = bat.slice("runs", "hr", "rbi", "sb", "average")
	# 					espn_weighted = espn.values.map{|m| m.to_f * e_weight}
	#
	# 					total = [espn_weighted, steamer_weighted].transpose.map{|m| m.reduce(:+).to_f}
	#
	# 					bat.update(runs: total[0], hr: total[1], rbi: total[2], sb: total[3], average: total[4],
	# 						adp: row[:adp], wrc: row[:wrc], games: row[:g], ab: row[:ab], hits: row[:h],
	# 						double: row[:"2b"], triple: row[:"3b"], bb: row[:bb], so: row[:so])
	# 				else
	# 					bat_year_exist << "#{player.first_name} #{player.last_name} has no season data"
	# 				end #end check if player has a batting record for this year
	# 			else
	# 				player_exist << "Player doesn't exist #{row[:name].split[0]} #{row[:name].split[1]} "
	# 			end #check if player exits in db (if!p.nil?)
	# 	end #end loop through fg (csv table object)
	# end #end fangraphs

	# desc "FanGraphs Pitcher Stats"
	# task :fangraphs_pitcher => :environment do
	# 		year = 2017
	# 		s_weight = 0.3 #weight to be applied to FanGraphs statistics
	# 		e_weight = 0.7  #weight for espn stats
	#
	# 		player_exist = [] #gather list of players who aren't in db
	# 		pitch_year_exist = [] #gather list of players with no batting records in db
	# 		fg = CSV.read('lib/csv_files/FanGraphsLeaderboardpitch.csv', {headers: true, header_converters: :symbol})
	# 		fg.each do |row|
	# 			player = Player.where(first_name: row[:name].split[0], last_name: row[:name].split[1]).first
	# 			if !player.nil?
	# 				pitch = Pitching.where(player_id: player[:id], year: year).first
	# 				if !pitch.nil?
	# 					steamer = row.to_h.slice(:w, :era, :so, :whip)
	# 					steamer_weighted = steamer.values.map{|m| m.to_f * s_weight}
	#
	# 					espn = pitch.slice("wins", "era", "so", "whip")
	# 					espn_weighted = espn.values.map{|m| m.to_f * e_weight}
	#
	# 					total = [espn_weighted, steamer_weighted].transpose.map{|m| m.reduce(:+).to_f}
	#
	# 					pitch.update(wins: total[0], era: total[1], so: total[2], whip: total[3],
	# 						games: row[:g], gs: row[:gs], innings: row[:ip], er: row[:er], bb: row[:bb],
	# 						hits: row[:h], adp: row[:adp], fip: row[:fip])
	# 				else
	# 					pitch_year_exist << "#{player.first_name} #{player.last_name} has no season data"
	# 				end #end check if player has a batting record for this year
	# 			else
	# 				player_exist << "Player doesn't exist #{row[:name].split[0]} #{row[:name].split[1]} "
	# 			end #check if player exits in db (if!p.nil?)
	# 	end #end loop through fg (csv table object)
	# end #end fangraphs pitcher

end #end CSV name space
