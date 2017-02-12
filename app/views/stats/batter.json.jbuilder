json.players(@players) do |player|
  json.(player, :first_name, :last_name, :birthday)

  json.stats player.battings do |bat|
  	json.(bat, :runs)
  	json.team bat.mlbteam.abbr
  end
	# json.array!(player.battings) do |batting|
 #  	json.year batting.year
 #  end
  # json.url owner_url(owner, format: :json)
end


# json.array!(@lenders) do |json, lender|
#   json.(lender, :id, :email, :latitude, :longitude)
#   json.inventories lender.inventories do |json, inventory|
#     json.(inventory, :id, :itemlist_id, :description)
#   end
# end