class AddReferenceOwnerIdToPlayer < ActiveRecord::Migration
  def change
    add_reference :players, :owner, index: true, foreign_key: true
  end
end
