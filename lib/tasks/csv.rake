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

end
