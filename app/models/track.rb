class Track < ActiveRecord::Base
  belongs_to :artist
  has_and_belongs_to_many :stations
  validates_uniqueness_of :title, :scope => :artist_id
  
end
