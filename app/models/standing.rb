class Standing

  attr_accessor :owner_id, :owner_first, :owner_last, :total_points, :run, :hr, :rbi, :sb, :average, :win, :so, :era, :whip, :sv,
    :run_points, :hr_points, :rbi_points, :sb_points, :average_points, :win_points, :sv_points, :so_points, :era_points, :whip_points

  # array [0] = owner id and array[1] = total poits
  def initialize (array, bat_hash, pitch_hash, team_points)
    o = Owner.find(array[0])
    @owner_id = array[0]
    @owner_first = o.first_name
    @owner_last = o.last_name
    @total_points = array[1]
    @run = bat_hash[:runs]
    @hr = bat_hash[:hr]
    @rbi = bat_hash[:rbi]
    @sb = bat_hash[:sb]
    @average = bat_hash[:average]
    @win = pitch_hash[:wins]
    @so =  pitch_hash[:so]
    @era = pitch_hash[:era]
    @whip = pitch_hash[:whip]
    @sv = pitch_hash[:sv]
    @run_points = team_points[0]
    @hr_points = team_points[1]
    @rbi_points = team_points[2]
    @sb_points = team_points[3]
    @average_points = team_points[4]
    @win_points = team_points[5]
    @sv_points = team_points[6]
    @so_points = team_points[7]
    @era_points = team_points[8]
    @whip_points = team_points[9]
  end

  def self.build_standings(options = {})
    year = options[:year] || Time.now.year
    standings = []
    bat_hash = {}
    pitch_hash = {}
    # project_team_standings returns an array, the position 0 is a hash with team point totals for each category
    # and position 1 a hash with owner_id and team total points
    ts = TeamSeason.project_team_standings
    ts[1].sort_by {|k, v| v}.reverse.to_a.each do |a|
       bat_hash = Batting.team_totals(year, a[0], true)
       pitch_hash = Pitching.team_totals(year, a[0], false)
       team_points = self.build_team_points(a[0], ts[0])
			 standings << self.new(a, bat_hash, pitch_hash, team_points)
		end
    return standings
  end

  def self.build_team_points(owner_id, team_season)
    team_cat_points = []
    # ts = TeamSeason.project_team_standings
    # o = ts[1].sort_by{|k, v| v}.reverse.to_h.keys
    # o.each do |o|
    	temp_array = []
    	team_season.each do |k, v|
    		team_cat_points << v.select {|k, v| k == owner_id}.map{|k,v| v}
    	end
    	# points_by_team << temp_array
    # end
    return team_cat_points.flatten
  end

end
