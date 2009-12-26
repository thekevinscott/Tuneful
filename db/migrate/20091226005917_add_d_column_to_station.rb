class AddDColumnToStation < ActiveRecord::Migration
  def self.up
    add_column :Stations, :title, :string
    add_column :Stations, :hash, :string
    add_column :Stations, :url, :string
  end

  def self.down
    remove_column :Stations, :title
    remove_column :Stations, :hash
    remove_column :Stations, :url
    
  end
end
