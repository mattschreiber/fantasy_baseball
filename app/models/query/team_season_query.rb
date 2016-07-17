module Query::TeamSeasonQuery

	############################################################################ 
	# This module will store queries on the TeamSeason model that may be used by 
	# other classes like ones for creating reports
	############################################################################

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
			# returns the average for all seasons by category (aka TeamSeason.column_name)
			begin
				TeamSeason.average(attributes[:category])
			rescue Exception => e
				return error = "invalid category"
			end
			
		end
	end

end