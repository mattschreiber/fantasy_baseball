class Owner < ActiveRecord::Base
	has_many :team_seasons, dependent: :destroy
end
