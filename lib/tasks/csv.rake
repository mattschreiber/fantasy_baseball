namespace :csv do
	desc "Update batters assigned to each owner"
	task :owner_batter => :environment do
		csv_import('lib/csv_files/o_p.csv')
	end
	desc "Update pitchers assigned to each owner"
	task :owner_pitcher => :environment do
		csv_import('lib/csv_files/o_pitcher.csv')
	end


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
				exist << "Player doesn't exist: #{r[1]} #{r[2]}"
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

end
