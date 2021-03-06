class Track
  
  include MongoMapper::Document
  
  key :title, String, :required => true
  key :artist_id, ObjectId, :required => true
  key :album, String
  key :file, String
  key :verified, Boolean, :default => false
  key :youtubed, Boolean, :default => false
  key :duration, Integer, :default => 0
  key :vote, Integer, :default => 0
  key :number_of_votes, Integer, :default => 0
  key :votes, Array
  key :start, Integer, :default => 0
  key :errors, String
  
  
  belongs_to :artist
  many :stations
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
  
  
  
  
  
  def cleanup(file1,file2)
    
    if File.exist?(file1)
      File.delete(file1) 
    end
    if File.exist?(file2)    
      File.delete(file2)
    end
  end
  
  
  
  def upload
    require 'rubygems'      
    require 'net/http'
    require 'cgi'
    require 'youtube_g'
  
    writefolder = "#{RAILS_ROOT}/files"
  
    puts '************************'
    puts '********* [ song uploader ]'
  
    user = 'tunefulapp'
    pass = '$!tuneful$!'
    developer_key = 'AI39si7gdDFDhYlXhbkocUvVMlzcA7nQQTBGXfp7B8PRSXAT1DK4HJfikLNxt0FbMrmgwaYpsPjJTJNuTytBW-nCqAPnGF_5jA'
  
  
    url = 'http://skreemr.com/results.jsp?q='+self.title.split(' ').join('+')+'+'+self.artist.title.split(' ').join('+')
  
    puts '********* [ contacting skreemr for the mp3s ]'
    puts '********* [ skreemr url: '+url+' ]'
    page = Net::HTTP.get_response(URI.parse(url)).body
  
    puts '********* [ scraping skreemr response ]'
    if page.index('soundFile').nil?
      puts '********* [ no file found, somehow alert us! ]'
      self.errors = 'No file found on skreemr'
      self.save
      return nil;
    end
      
    start = page.index('soundFile')+9


    page = page[start..-1]
    ending = page.index("'>")-1
    page = page[1..ending]
    @source = CGI::unescape(page)

    puts '********* [ mp3 hosting server is : '+@source[7..-1].split('/').shift+']'
    puts '********* [ full mp3 file path : '+@source+']'

    puts '********* [ download mp3 file locally ]'

    @localsource = writefolder+self.title.split(' ').join('_')+'_'+self.artist.title.split(' ').join('_')+'.mp3'

    Net::HTTP.start(@source[7..-1].split('/').shift) { |http|
      resp = http.get(@source)
      open(@localsource, "w") { |file|
          file.write(resp.body)
      }
    }

    
    puts '********* [ mp3 file downloaded ]'
    
    
    if ! File.exist?(@localsource)
      self.errors = "Error downloading the file"
      self.save
      puts '********* [ error downloading file '+@localsource+', somehow alert us! ]'
      
      return nil;     
    end
    
    # get length
    
    puts '********* [ getting duration of mp3 file ]'
    d = `ffmpeg -i #{@localsource} 2>&1 | grep "Duration" | cut -d ' ' -f 4 | sed s/,//`
    d = d.split(':')
    duration = (d[0].to_i*60*60)+(d[1].to_i*60)+d[2].to_f
    
    puts '********* [ duration is '+duration.to_s+' ]'
    #t = Track.first(:title=>self.title,:artist_id=>Artist.first(:title=>artist).id)
    self.youtubed = true
    self.duration = duration
        

    file = ((rand*10000000000000)+10000000000000).round.to_s+'.mov'

    @target = writefolder + file


    puts '********* [ run ffmpeg to create new video ]'
    command = 'ffmpeg -i '+@localsource+' -ar 44100 -f image2 -i '+writefolder+'/tuneful.jpg -loop_input -shortest -ab 512 -r 1 -b 100 -s 640x480 '+@target
    puts command
    #command.gsub!(/\s+/, " ")

    #exec command

    #exec command
    system command

    puts '********* [ ffmpeg complete ]'
    
    
    if ! File.exist?(@target)
      puts '********* [ error creating file via ffmpeg, somehow alert us! ]'
      self.errors = "Could not create file via ffmpeg"
      self.save
      self.cleanup(@localsource,@target)
      return nil;     
    end
    
    
    puts '********* [ uploading to youtube ]'
    uploader = YouTubeG::Upload::VideoUpload.new(user, pass, developer_key)
    @target_title = @target.split('/').pop
    youtube_url = uploader.upload File.open(@target), :title=>@target_title,:description=>@target,:category=>'People',:keywords=>%w[tuneful]
    puts '********* [ file successfully uploaded to youtube ]'


    self.cleanup(@localsource,@target)
    
    #t = Track.find(:first, :conditions => "title='"+track+"' AND artist_id=(SELECT id FROM artists WHERE title='"+artist+"') ")

    
    self.file = youtube_url
        
    #puts '********* [ open up new youtube client ]'
		#client = YouTubeG::Client.new
		
		#@media = client.video_by youtube_url
    
		#@media = client.videos_by(:user => 'tunefulapp', :query=>@target_title ).videos[0]
  
    #t.duration = @media.duration
    #t.file = @media.media_content[0].url.split('/').pop.split('?').shift

    self.save
    
    puts '******* [ all done! ]'
  
  end
  
  
  
end
