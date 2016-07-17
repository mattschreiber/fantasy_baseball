require 'rails_helper'

TeamSeason.destroy_all

	describe CategoryAverage do
		context "Dynamic properties added for calculating category averages" do
			it { is_expected.to respond_to(:total_run_avg) } 
    	it { is_expected.to respond_to(:total_hr_avg) } 
    	it { is_expected.to respond_to(:total_rbi_avg) } 
    	it { is_expected.to respond_to(:total_sb_avg) } 
    	it { is_expected.to respond_to(:total_avg_avg) } 
    	it { is_expected.to respond_to(:total_win_avg) } 
    	it { is_expected.to respond_to(:total_k_avg) } 
    	it { is_expected.to respond_to(:total_era_avg) } 
    	it { is_expected.to respond_to(:total_whip_avg) } 
    	it { is_expected.to respond_to(:total_sb_avg) } 
    end
    context "Dynamic properties added for calculating category average by year and/or place" do
  		it { is_expected.to respond_to(:run_by_place) }
  		it { is_expected.to respond_to(:hr_by_place) }
  		it { is_expected.to respond_to(:rbi_by_place) }
  		it { is_expected.to respond_to(:sb_by_place) }
  		it { is_expected.to respond_to(:avg_by_place) }     
  		it { is_expected.to respond_to(:win_by_place) } 
  		it { is_expected.to respond_to(:k_by_place) }
  		it { is_expected.to respond_to(:sv_by_place) }
  		it { is_expected.to respond_to(:era_by_place) }   
  		it { is_expected.to respond_to(:whip_by_place) }
  	end



    # it "has a total_hr" do
    # 	season = build(:team_season)
    # 	expect(season.total_hr).to eq(225)
  	# end
  	# context "Mutiple Factories" do
  	# 	it "calculates average hr" do
  	# 		season = create_list(:team_season, 4)
  	# 		# expect(season.average[:total_hr]).to eq(225)

  	# 	end
  	# end

	end