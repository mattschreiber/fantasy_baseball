# This class will serve to calculate category averages such as the average number of 
# homeruns per team per season.

class CategoryAverage

	attr_reader :run_avg, :hr_avg, :rbi_avg, :sb_avg, :batting_avg, :win_avg, :k_avg,
							:sv_avg, :era_avg, :whip_avg

	
	def initialize 
		category_averages
	end

	def self.calc_avg(category)
		TeamSeason.average(:"#{category}").round(2).to_s
	end

	def self.hash_avg
		h = {}
		array = []
		TeamSeason.all.each do |season|
			TeamSeason.column_names.slice(1..-3).each {|r| h["#{r}"] = season[:"#{r}"]}
			array << h
			h = {}
		end
		return array

		# hr_avg = arr.map{|a| a["total_hr"]}.reduce(:+)/arr.length
	end

	#only calculates averages for actual totals not point categories
	def category_averages
		#calculate totals for each category
		TeamSeason.all.each do |season|
			@run_avg = season.total_run + (@run_avg.nil? ? 0 : @run_avg)
			@hr_avg = season.total_hr + (@hr_avg.nil? ? 0: @hr_avg)
			@rbi_avg = season.total_rbi + (@rbi_avg.nil? ? 0 : @rbi_avg)
			@sb_avg = season.total_sb + (@sb_avg.nil? ? 0 : @sb_avg)
			@batting_avg = season.total_avg + (@batting_avg.nil? ? 0 : @batting_avg)

			@win_avg = season.total_win + (@win_avg.nil? ? 0 : @win_avg)
			@k_avg = season.total_k + (@k_avg.nil? ? 0 : @k_avg)
			@sv_avg = season.total_sv + (@sv_avg.nil? ? 0 : @sv_avg)
			@era_avg = season.total_era + (@era_avg.nil? ? 0 : @era_avg)
			@whip_avg = season.total_whip + (@whip_avg.nil? ? 0 : @whip_avg)
		end
		# calculate average
		count = TeamSeason.count
		@run_avg = @run_avg / count.to_f
		@hr_avg = @hr_avg / count.to_f
		@rbi_avg = @rbi_avg / count.to_f
		@sb_avg = @sb_avg / count.to_f
		@batting_avg = @batting_avg / count.to_f

		@win_avg = @win_avg / count.to_f
		@k_avg = @k_avg / count.to_f
		@sv_avg = @sv_avg / count.to_f
		@era_avg = @era_avg / count.to_f
		@whip_avg = @whip_avg / count.to_f
	end

end