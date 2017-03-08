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



end
