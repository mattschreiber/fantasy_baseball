# This class will serve to calculate category averages such as the average number of 
# homeruns per team per season.

class CategoryAverage

	attr_reader :total_run_avg, :total_hr_avg, :total_rbi_avg, :total_sb_avg, :total_avg_avg, :total_win_avg, :total_k_avg,
							:total_sv_avg, :total_era_avg, :total_whip_avg

	
	def initialize 
		# category_averages
		self.class.calc_all
	end

	def self.calc_one(category)
		TeamSeason.average(:"#{category}").to_s
	end

	def self.calc_all
		#class method that returns hash of category averages. hash keys match class attributes
		hash = {}
		TeamSeason.column_names.each do |name|
			hash[:"#{name}_avg"] = calc_one(name) unless TeamSeason.column_for_attribute(name).type == :datetime
		end
		return hash
	end

	#only calculates averages for actual totals not point categories
	def category_averages
		#calculate totals for each category
		TeamSeason.all.each do |season|
			@total_run_avg = season.total_run + (@total_run_avg.nil? ? 0 : @total_run_avg)
			@total_hr_avg = season.total_hr + (@total_hr_avg.nil? ? 0: @total_hr_avg)
			@total_rbi_avg = season.total_rbi + (@total_rbi_avg.nil? ? 0 : @total_rbi_avg)
			@total_sb_avg = season.total_sb + (@total_sb_avg.nil? ? 0 : @total_sb_avg)
			@total_avg_avg = season.total_avg + (@total_avg_avg.nil? ? 0 : @total_avg_avg)

			@total_win_avg = season.total_win + (@total_win_avg.nil? ? 0 : @total_win_avg)
			@total_k_avg = season.total_k + (@total_k_avg.nil? ? 0 : @total_k_avg)
			@total_sv_avg = season.total_sv + (@total_sv_avg.nil? ? 0 : @total_sv_avg)
			@total_era_avg = season.total_era + (@total_era_avg.nil? ? 0 : @total_era_avg)
			@total_whip_avg = season.total_whip + (@total_whip_avg.nil? ? 0 : @total_whip_avg)
		end
		# calculate average
		count = TeamSeason.count
		@total_run_avg = @total_run_avg / count.to_f
		@total_hr_avg = @total_hr_avg / count.to_f
		@total_rbi_avg = @total_rbi_avg / count.to_f
		@total_sb_avg = @total_sb_avg / count.to_f
		@total_avg_avg = @total_avg_avg / count.to_f

		@total_win_avg = @total_win_avg / count.to_f
		@total_k_avg = @total_k_avg / count.to_f
		@total_sv_avg = @total_sv_avg / count.to_f
		@total_era_avg = @total_era_avg / count.to_f
		@total_whip_avg = @total_whip_avg / count.to_f
	end

end