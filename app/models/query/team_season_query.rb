module Query::TeamSeasonQuery

	# return ActiveRecord::Relations based on query params
	# accepted params :year, :place
	def filter(attributes)
		case 
		when attributes[:place].present? && attributes[:year].present?
			TeamSeason.where("place = :place and year = :year", place: attributes[:place], year: attributes[:year])
		when attributes[:place]
			TeamSeason.where("place = :place", place: attributes[:place])
		when attributes[:year]
			TeamSeason.where("year = :year", year: attributes[:year])				
		else
				return error_msg = "Invalid search parameters"
		end
	end

end