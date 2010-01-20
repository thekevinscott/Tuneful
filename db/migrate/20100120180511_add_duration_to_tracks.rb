class AddDurationToTracks < ActiveRecord::Migration
  def self.up

    add_column :Tracks, :duration, :integer
  end

  def self.down
    remove_column :Tracks, :duration
  end
end
