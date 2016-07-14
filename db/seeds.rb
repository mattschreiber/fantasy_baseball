# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Owner.destroy_all
TeamSeason.destroy_all

# fn = ["Matt", "Scott", "Alan", "Mike", "Pete", "Mike", "Jay", "James", "Joe", "David", "James","", "Mike", "Mike", "Brian", "Scott"]
# ln = ["Schreiber", "Pierce", "Thomay", "Thellman", "Tran", "Kelly", "Zadzilka",
# 			"Ungerer", "Shaw", "Thompson", "Wailani","", "McNamara", "Hoendorf", "Sweet", "Reifschneider"]
# tn = ["Pink Unicorns", "Silver Sluggers", "Morgantown Swingers", "Championship Vinyl",
# 			"Rockford Peaches", "Shiva Bastards", "Brunswick Bulldozers", "Fluffy White Bunnies",
# 			"The Florida Dumpster Fire", "Greenbriar Sycamores", "", "Alderaan Asteroid","", "", "", ""]
# id = [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

# # Owner.create(first_name: "Matt", last_name: "Schreiber", team_name: "Pink Unicorns")

# fn.length.times do |n|
# 	Owner.create!(id: id[n], first_name: fn[n], last_name: ln[n], team_name: tn[n])
# end

file = File.read('db/owners.json')
data_hash = JSON.parse(file)
data_hash.each do |r|
  Owner.create!(r)
end

file = File.read('db/team_seasons.json')
data_hash = JSON.parse(file)
data_hash.each do |r|
  TeamSeason.create!(r)
end


