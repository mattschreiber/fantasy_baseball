# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Owner.destroy_all

fn = ["Matt", "Scott", "Alan", "Mike", "Pete", "Mike", "Jay", "James", "Joe", "David"]
ln = ["Schreiber", "Pierce", "Thomay", "Thellman", "Tran", "Kelly", "Zadzilka",
			"Ungerer", "Shaw", "Thompson"]
tn = ["Pink Unicorns", "Silver Sluggers", "Morgantown Swingers", "Championship Vinyl",
			"Rockford Peaches", "Shiva Bastards", "Brunswick Bulldozers", "Fluffy White Bunnies",
			"The Florida Dumpster Fire", "Greenbriar Sycamores"]

# Owner.create(first_name: "Matt", last_name: "Schreiber", team_name: "Pink Unicorns")

10.times do |n|
	Owner.create!(first_name: fn[n], last_name: ln[n], team_name: tn[n])
end