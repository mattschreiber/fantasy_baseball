class AddAdpAndFipToPitching < ActiveRecord::Migration
  def change
    add_column :pitchings, :adp, :float
    add_column :pitchings, :fip, :float
  end
end
