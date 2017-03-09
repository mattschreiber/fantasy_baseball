require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
Capybara.default_driver = :poltergeist
Capybara.run_server = false

namespace :mlb do
  desc "Update mlb rankings"
  task :mlb_ranking => :environment do
    mlb_rankings = MlbProjections.new
    mlb_rankings.get_page_data
    PlayerRanking.update_all(mlb: nil)
    mlb_rankings.update_mlb_rankings('lib/csv_files/mlb_batter_projections.csv')
    mlb_rankings.update_mlb_rankings('lib/csv_files/mlb_pitcher_projections.csv')
  end
end


class MlbProjections
  include Capybara::DSL
  def get_page_data(options = {})
    url = options[:url] || 'http://m.mlb.com/fantasy/preview/y2017'
    batter = "lib/csv_files/mlb_batter_projections.csv"
    pitcher = "lib/csv_files/mlb_pitcher_projections.csv"
    visit(url)
    doc = Nokogiri::HTML(page.html)

    player_array = []
    CSV.open(pitcher, "w+") {|blank|} #create blank document
    CSV.open(batter, "w+") {|blank|} #create blank document
    doc.css('li').each do |li|
      if li.css('.ribbon').text.split[0] == "SP"
        CSV.open(pitcher, "a+") do |csv|
          csv << [li.css('.rank').text, li.css('.player-name').text.split[0], li.css('.player-name').text.split[1],
                  li.css('.stats-line').text.split[0].match('^.*(?=-)')[0], li.css('.stats-line').text.split[1],
                  li.css('.stats-line').text.split[3], li.css('.stats-line').text.split[5], "", li.attr('data-player-id')]
        end
      elsif li.css('.ribbon').text.split[0] == "RP"
        CSV.open(pitcher, "a+") do |csv|
          csv << [li.css('.rank').text, li.css('.player-name').text.split[0], li.css('.player-name').text.split[1],
                  "", li.css('.stats-line').text.split[2], li.css('.stats-line').text.split[4], li.css('.stats-line').text.split[6],
                li.css('.stats-line').text.split[0], li.attr('data-player-id')]
        end
      else
        CSV.open(batter, "a+") do |csv|
          csv << [li.css('.rank').text, li.css('.player-name').text.split[0], li.css('.player-name').text.split[1],
                  li.css('.stats-line').text.split[1], li.css('.stats-line').text.split[3], li.css('.stats-line').text.split[5],
                  li.css('.stats-line').text.split[7], li.css('.stats-line').text.split[0], li.attr('data-player-id')]
        end
      end
    end #end doc.each

  end #end get_page_data

  def update_mlb_rankings(file)
    new_rank = []
		exist = []
		doc = CSV.read("#{file}")
		doc.each do |r|
			#search for player (assumes first_name in second column and last_name is 3rd col)
			play = Player.where(first_name: r[1], last_name: r[2]).first
			if !play.nil?
				if PlayerRanking.find_by(player_id: play.id)
					PlayerRanking.find_by(player_id: play.id).update(mlb: r[0])
				else
					PlayerRanking.create(player_id: play.id, mlb: r[0])
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
end #end MlbProjections
