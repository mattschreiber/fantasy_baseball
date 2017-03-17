class Standing

  attr_accessor :owner_id, :owner_first, :owner_last, :total_points, :run, :hr, :rbi, :sb, :average, :win, :so, :era, :whip, :sv

  # array [0] = owner id and array[1] = total poits
  def initialize (array, bat_hash, pitch_hash)
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
  end

  def self.build_standings(options = {})
    year = options[:year] || Time.now.year
    standings = []
    bat_hash = {}
    pitch_hash = {}
    # project_team_standings returns an array, the position 0 is a hash with team point totals for each category
    # and position 1 a hash with owner_id and team total points
    TeamSeason.project_team_standings[1].sort_by {|k, v| v}.reverse.to_a.each do |a|
       bat_hash = Batting.team_totals(year, a[0], true)
       pitch_hash = Pitching.team_totals(year, a[0], false)
			 standings << self.new(a, bat_hash, pitch_hash)
		end
    return standings
  end

end
