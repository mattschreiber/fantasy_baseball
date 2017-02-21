module ApplicationHelper

	BAT_CATEGORIES = ["First", "Last", "Team", "Runs", "Home Runs", "RBIs", "SB", 
		"BA", "Edit"]
	
	def round_zero points
		points.round(0)
	end

	def round_4 points
		points.round(4)
	end

	def round_2 points
		points.round(2)
	end

	def to_int points
		points.to_i
	end

	def age(bd)
		now = Time.now
		if bd.month < now.month
			age = age = now.year - bd.year
		else
			age = now.year - bd.year - 1
		end
	end

	def name(first_name, last_name)
		"#{first_name} #{last_name}"
	end
	
end
