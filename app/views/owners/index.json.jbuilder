json.array!(@owners) do |owner|
  json.extract! owner, :id, :first_name, :last_name, :team_name, :place_avg, :total_points_avg, :num_titles
  json.url owner_url(owner, format: :json)
end
