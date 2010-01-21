class AddDeletedToStationsTracks < ActiveRecord::Migration
  def self.up
    
    add_column :stations_tracks, :deleted, :boolean, {:default=>0}
  end

  def self.down
    remove_column :stations_tracks, :deleted
  end
end
