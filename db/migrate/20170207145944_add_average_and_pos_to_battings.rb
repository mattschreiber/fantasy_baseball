class AddAverageAndPosToBattings < ActiveRecord::Migration
  def change
  	add_column :battings, :average, :float
  	add_column :battings, :pos, :string
  end
end
