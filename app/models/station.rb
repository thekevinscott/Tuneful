class Station < ActiveRecord::Base
  has_and_belongs_to_many :tracks
  has_and_belongs_to_many :users
  
  
  def get_playlist
    @tracks = JSON.parse self.playlist
    @total_playlist_duration = @tracks.inject(0) { |result, element| result + element["duration"] } 
    #@total_playlist_duration = 60*60
    start = self.playlist_start.to_i
    if Time.now.to_i > start + @total_playlist_duration # cycle through so we're *in* a playlist
      start += ((Time.now.to_i-Station.first.playlist_start.to_i) / @total_playlist_duration) * @total_playlist_duration # we have to floor it here
    end
    
    time_to_jump = Time.now.to_i - start
    
    running_duration = start
    current = nil
    last_duration = 0
    #return @tracks
    @tracks.each_with_index do |p, index|
      if running_duration < Time.now.to_i
        current = index
        running_duration += p['duration']
        last_duration = p['duration']
      end
    end
    running_duration -= last_duration
    
    if current >= @tracks.length
      ender = 1
    else
      ender = 2
    end
    
    @playlist = []
    for i in 1..ender
      @t = Track.find(@tracks[current+i]['id'])
      if i == 1
        @start = Time.zone.now.to_i - running_duration
      else
        @start = 0
      end
      
      @playlist.push({:id=>@t.id,:title=>@t.title,:artist=>@t.artist.title,:album=>@t.album,:file=>@t.file,:start=>@start,:duration=>@t.duration})
    end
    
    
    @station = {:title=>self.title,:url=>self.url}
    
    return {:station=>@station,:playlist=>{:servertime=>Time.zone.now.to_i,:tracks=>@playlist}}
    
    
  end
  
  def generate_playlist
    
      @subscribers = 20 # this should be the subscribers on the station, we don't have that yet. Probably should stay above 5 or so

      min_vote = 0
      max_vote = 0
      @total_vote_num = 0
      @total_vote_sum = 0
      @avg_duration = 0
      self.tracks.each do |t|
        if t.vote < (@subscribers * 1)
          t.deleted = true
          # mark this track for deletion
        end
        if @subscribers > t.number_of_votes # if a track has less votes then the number of 
          v = @subscribers - t.number_of_votes
          t.vote = v + t.vote
          @total_vote_num += v
        end
        
        #### there should be some time weighting here. longer tracks should be played less
        
        if min_vote > t.vote
          min_vote = t.vote
        end
        if max_vote < t.vote
          max_vote = t.vote
        end
        
        @total_vote_num += t.number_of_votes
        @total_vote_sum += t.vote
        @avg_duration += t.duration
      end
      
      @avg_duration = @avg_duration / @tracks.length
      
      
      @plays_in_a_day = (86400 / @avg_duration).round
      #return @plays_in_a_day
      #x = (max_vote * @plays_in_a_day / 24) - @total_vote_num
      #return x
      x = 100 
      @total_vote_num += (x*@tracks.length)
      #@tracks = 
      self.tracks.each do |t| # increase all tracks votes by the lowest rated song
	      t.set_frequency(min_vote,@total_vote_num,@plays_in_a_day,x)
        #{:id=>t.id,:freq=>((t.vote + min_vote + x + 0.0) / @total_vote_num * @plays_in_a_day).round,:duration=>t.duration}
        #{:id=>t.id,:freq=>((t.vote + min_vote + x + 0.0))}
      end
      
      # then we sort the tracks, by frequency, ascending
      #@tracks = @tracks.sort_by {|t| t[:freq] }
      self.tracks.sort_by {|t| t.frequency }
      

      old_arr = []
            
      self.tracks.each do |t| 
      
        
        arr = []
        
        
        total = t.frequency + old_arr.length
        
        
        x = total / t.frequency
        
        for i in 1..total
	        if i%x < 1
            arr.push({:id=>t[:id],:duration=>t[:duration]})
          else
            arr.push(old_arr.shift)
          end
          
        end
        old_arr = arr
      end
      
      
      @playlist = old_arr.to_json
      self.playlist = @playlist
      self.playlist_start = Time.zone.now.to_s(:db)
      self.save()
      self.update_changed_tracks()
      return @playlist
      
  end
  
  def update_changed_tracks
    self.tracks.each do |track|
      #track.save! if track.changed?
    end
  end
  
  def get_station_duration
    duration = 0
    self.tracks.each do |t|
      duration += t.duration
    end
    return duration
  end
  
end
