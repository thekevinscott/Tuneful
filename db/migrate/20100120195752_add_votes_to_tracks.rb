class AddVotesToTracks < ActiveRecord::Migration
  def self.up

    add_column :Tracks, :vote, :integer, {:default=>0}
    add_column :Tracks, :number_of_votes, :integer, {:default=>0}
  end

  def self.down
    remove_column :Tracks, :vote
    remove_column :Tracks, :number_of_votes
  end
end
