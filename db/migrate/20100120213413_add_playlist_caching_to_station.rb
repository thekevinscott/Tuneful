class AddPlaylistCachingToStation < ActiveRecord::Migration
  def self.up
    
    add_column :Stations, :playlist, :text
    add_column :Stations, :playlist_start, :datetime
  end

  def self.down
    remove_column :Stations, :playlist
    remove_column :Stations, :playlist_start
  end
end
