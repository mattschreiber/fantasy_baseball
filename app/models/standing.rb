class Standing

  attr_accessor :owner_first, :owner_last, :total_points

  # array [0] = owner id and array[1] = total poits
  def initialize (array)
    o = Owner.find(array[0])
    @owner_first = o.first_name
    @owner_last = o.last_name
    @total_points = array[1]
  end

  def self.build_standings
    standings = []
    TeamSeason.project_team_standings.sort_by {|k, v| v}.reverse.to_a.each do |a|
			standings << self.new(a)
		end
    return standings
  end

end
