class Track < ActiveRecord::Base
  belongs_to :artist
  has_and_belongs_to_many :stations
  validates_uniqueness_of :title, :scope => :artist_id

  def set_frequency(min_vote,total_votes,plays_in_a_day,x_factor=100)
    vote_base = self.vote + min_vote + x_factor
    # puts "vote_base: #{vote_base}"
    unrounded_frequency = (vote_base.to_f / total_votes	* plays_in_a_day)
    @frequency = unrounded_frequency.round
  end

  #def title
    #base_title = super
    #"My funky #{base_title}"
  #end

  def frequency
    @frequency || 0.to_f
  end
  
end
