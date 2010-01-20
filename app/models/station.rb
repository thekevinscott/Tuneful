class Station < ActiveRecord::Base
  has_and_belongs_to_many :tracks
  
  
  def get_playlist
    @tracks = self.tracks
    @playlist = []
    for i in 0..1 do
      @t = @tracks.rand
      @track = {:id=>@t.id,:title=>@t.title,:artist=>@t.artist.title,:album=>@t.album,:file=>@t.file}
      @playlist.push(@track)
    end
    @station = {:title=>self.title,:url=>self.url}
    #self[:playlist] = @playlist
    
    return {:station=>@station,:playlist=>{:servertime=>123,:tracks=>@playlist}}
  end
  
end
