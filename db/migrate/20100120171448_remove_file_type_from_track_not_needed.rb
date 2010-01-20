class RemoveFileTypeFromTrackNotNeeded < ActiveRecord::Migration
  def self.up
    remove_column :Tracks, :file_type
  end

  def self.down
    add_column :Tracks, :file_type, :string
  end
end
