module PlayerProjection
  extend ActiveSupport::Concern

  module ClassMethods
    # returns hash with player_id and total points based on rankings in each categories
    def category_compare(params)
      player_totals = Hash.new(0)
      player_array = []
      year = params[:year] || Time.now.year
      # check params hash for any params that include category as key
      categories = []
      weights = []
      params.each do |k,v|
        if /^category(.*)/.match(k)
          categories << v
        end
        if /^num(.*)/.match(k)
          if !v.blank?
            weights << v.to_f
          else
            weights << 1 #set weight to 1 if no weight found in params
          end
        end
      end #end search for categories in params hash
      i = 0 # iterator to apply appropriate weight to each category
      categories.each do |category|
          temp_hash = {}
          player_hash = {}
          if category == 'era' || category == 'whip'
            temp_hash = self.joins(player: :player_ranking).where('year = ? AND players.avail = ?', year, true).order("#{category}": :asc).pluck(:player_id, :"#{category}").sort_by{|k,v| v}.to_h
          else
            temp_hash = self.joins(player: :player_ranking).where('year = ? AND players.avail = ?', year, true).order("#{category}": :desc).pluck(:player_id, :"#{category}").sort_by{|k,v| v}.reverse.to_h
          end #sort hash for ranking descending unless era or whip since lower is better for these 2 categories
          player_hash = TeamSeason.rankv2(temp_hash)
          player_hash.each {|k,v| player_hash[k] = v * weights[i]}
          player_totals.merge!(player_hash){|k, oldval, newval| oldval + newval}
          i += 1
      end #end categories loop
      return player_totals
    end #end category_compare method
  end # end of ClassMethods
end # end of module TeamProjection
