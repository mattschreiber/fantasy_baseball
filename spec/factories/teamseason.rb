# This will guess the TeamSeason class
FactoryGirl.define do
  factory :team_season do
    place 1
    year  2016
    total_run 900
    total_hr 225
    total_rbi 870
    total_sb 140
    total_avg 0.271
    total_win 88
    total_k 1295
    total_sv 110
    total_era 3.48
    total_whip 1.2
    owner_id 5
  end
end