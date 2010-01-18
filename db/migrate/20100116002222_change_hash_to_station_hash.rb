class ChangeHashToStationHash < ActiveRecord::Migration
  def self.up
    remove_column :Stations, :hash
    add_column :Stations, :station_hash, :string
    
  end

  def self.down
    remove_column :Stations, :station_hash
    add_column :Stations, :hash, :string
  end
end
