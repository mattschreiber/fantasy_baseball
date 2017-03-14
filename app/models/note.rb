class Note < ActiveRecord::Base
  belongs_to :player
  belongs_to :owner

  def self.watchlist(options={})
    owner_id = options[:owner_id] || 5 # defaults to my team
    available = options[:avail] || true #not sure if eventually want to show people even if they are on another team.
    watch_list = Note.joins(:player).where('notes.owner_id = ? AND notes.watch = ? AND players.avail = ?', owner_id, true, available)
  end
end
