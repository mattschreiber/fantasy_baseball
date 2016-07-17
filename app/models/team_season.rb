class TeamSeason < ActiveRecord::Base
	belongs_to :owner

	default_scope {order year: :desc}




def self.calc_season_points
	
	hash = {}
	sorted_hash = {}
	h= {}
	hash = TeamSeason.where(year: 2015).pluck(:owner_id, :total_hr).to_h
	sorted_hash = hash.sort_by{|owner, run| run}.reverse.to_h
	
	points = 10
	sorted_hash.keys.each do |k|
		h["#{k}"]= points
	points = points - 1
	
	end
	return h
end


end
