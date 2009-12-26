class AddImageToStation < ActiveRecord::Migration
  def self.up
    add_column :Stations, :image, :string
    
  end

  def self.down
    remove_column :Stations, :image
  end
end
