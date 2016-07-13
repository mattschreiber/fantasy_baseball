class TeamSeason < ActiveRecord::Base
	belongs_to :owner

	default_scope {order year: :desc}
end
