class Note < ActiveRecord::Base
  belongs_to :player
  belongs_to :owner
end
