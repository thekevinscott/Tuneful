class ChangepasswordToHashedPassword < ActiveRecord::Migration
  def self.up
    add_column :Users, :hashed_password, :string
    remove_column :Users, :password
  end

  def self.down
    remove_column :Users, :hashed_password    
  end
end
