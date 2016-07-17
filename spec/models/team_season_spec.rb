require 'rails_helper'

RSpec.describe TeamSeason, type: :model do
 #  before :all do
	# 	Owner.destroy_all
	# 	owner = Owner.create!(first_name: "Matt", last_name: "Schreiber", team_name: "Pink Unicorns")
	# 	@test_owner = {first_name: "Matt", last_name: "Schreiber", team_name: "Pink Unicorns"}
	# end
	TeamSeason.destroy_all

	describe TeamSeason do
		it "has a valid factory" do
    	expect(create(:team_season)).to be_valid
    end
    it "has a total_hr" do
    	season = build(:team_season)
    	expect(season.total_hr).to eq(225)
  	end
  	# context "Mutiple Factories" do
  	# 	it "calculates average hr" do
  	# 		season = create_list(:team_season, 4)
  	# 		# expect(season.average[:total_hr]).to eq(225)

  	# 	end
  	# end

	end

		# def class_exists?(class_name)
  #     eval("defined?(#{class_name}) && #{class_name}.is_a?(Class)") == true
  #   end

  #   context "Model TeamSeason" do #'Owner' model and database table
  #   	context "TeamSeason Model:" do
  #     	it "TeamSeason class created" do
  #     		expect(class_exists?("TeamSeason"))
  #         expect(TeamSeason < ActiveRecord::Base).to eq(true)        
  #       end
  #     end
  #    end
end
