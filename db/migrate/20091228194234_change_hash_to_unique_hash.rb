class ChangeHashToUniqueHash < ActiveRecord::Migration
  def self.up
    add_column :Users, :unique_hash, :string
    remove_column :Users, :hash
  end

  def self.down
    remove_column :Users, :unique_hash
  end
end
