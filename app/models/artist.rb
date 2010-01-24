class Artist
  include MongoMapper::Document
  
  
  
  key :title, String, :required => true
  key :tracks, Array, :required => true
  
  
  many :tracks
  validates_uniqueness_of :title
end
