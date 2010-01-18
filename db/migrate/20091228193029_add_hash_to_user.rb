class AddHashToUser < ActiveRecord::Migration
  def self.up
    add_column :Users, :hash, :string    
  end

  def self.down
    remove_column :Users, :hash
  end
end
