module ApplicationHelper

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
end
