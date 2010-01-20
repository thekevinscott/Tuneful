class AddUrLsToTracks < ActiveRecord::Migration
  def self.up
      add_column :Tracks, :file, :string
      add_column :Tracks, :file_type, :string
      add_column :Tracks, :verified, :boolean, {:default=>0}
  end

  def self.down    
      remove_column :Tracks, :file
      remove_column :Tracks, :file_type
      remove_column :Tracks, :verified      
  end
end
