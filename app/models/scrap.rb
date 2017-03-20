# find list of owner id's
o = Owner.where(active: true).order(:id).pluck(:id)

# This creates array that contains each teams team_totals by category (team_totals method is from team_projection concern)
arr = []
Owner.where(active: true).order(:id).each do |o|
  arr <<  Batting.team_totals(2017, o.id, true)
end

bat_hash = {}
# iterator to loop through each owner and create hash with owner id as key and category total as value
i = 0
arr.each do |a|
  if a[:runs].nil?
    bat_hash[o[i]] = 0
  else
    bat_hash[o[i]] = a[:runs]
  end
  i += 1
end

return bat_hash


def stand_deviation(array)
  # mean = (sd.reduce(:+)/sd.count) more efficient to caluculate mean once
  Math.sqrt(sd.map{|m| (m-(sd.reduce(:+)/sd.count))**2}.reduce(:+)/(sd.count.to_f-1)) #sample sd
  Math.sqrt(sd.map{|m| (m-(sd.reduce(:+)/sd.count))**2}.reduce(:+)/(sd.count.to_f)) #population sd
end
