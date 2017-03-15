class AddAdpAndWrcToBatting < ActiveRecord::Migration
  def change
    add_column :battings, :adp, :float
    add_column :battings, :wrc, :float
  end
end
