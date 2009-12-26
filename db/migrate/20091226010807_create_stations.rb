class CreateStations < ActiveRecord::Migration
  def self.up
    drop_table :stations
    create_table :stations do |t|
      t.string :title
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :stations
  end
end
