require 'rails_helper'

RSpec.describe TeamSeason, type: :model do
 #  before :all do
	# 	Owner.destroy_all
	# 	owner = Owner.create!(first_name: "Matt", last_name: "Schreiber", team_name: "Pink Unicorns")
	# 	@test_owner = {first_name: "Matt", last_name: "Schreiber", team_name: "Pink Unicorns"}
	# end

	describe TeamSeason do
		it "has a valid factory" do
    	expect(create(:team_season)).to be_valid
  	end
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
