class AddSubscribersToStation < ActiveRecord::Migration
  def self.up
    create_table :stations_users, :id => false do |t|
      t.references :user
      t.references :station
      t.timestamps
    end
  end

  def self.down
    drop_table :stations_users
  end
end