class Note < ActiveRecord::Base
  belongs_to :player
  belongs_to :owner

  def self.watchlist(options={})
    owner_id = options[:owner_id] || 5 # defaults to my team
    watch_list = Note.where(owner_id: owner_id, watch: true)
  end
end
