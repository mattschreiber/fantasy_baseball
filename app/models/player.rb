class Player < ActiveRecord::Base
	has_and_belongs_to_many :positions
	has_many :mlbteams, through: :batting
	has_many :battings
	has_many :pitchings

	def self.search(search, bat_pitch)
		if search.nil?
			search = ""
		end
		if bat_pitch.nil?
			bat_pitch = true
		end
  	where("last_name LIKE ? AND batter = ?", "%#{search}%", bat_pitch) 
	end

end
