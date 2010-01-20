class AddLinkageTableBetweenTracksAndStation < ActiveRecord::Migration
  def self.up
    create_table :stations_tracks, :id => false do |t|
      t.references :track
      t.references :station
      t.timestamps
    end
  end

  def self.down
    drop_table :stations_tracks    
  end
end