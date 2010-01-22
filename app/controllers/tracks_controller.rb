class TracksController < ApplicationController
  def test
  
    
    respond_to do |format|
    
      format.html { render :action => "upload" }
    end
  end
  def upload
    
    spawn do
      require 'net/http'
      require 'cgi'
      require 'youtube_g'
    
      puts '************************'
      puts '********* [ song uploader ]'
    
      user = 'tunefulapp'
      pass = '$!tuneful$!'
      developer_key = 'AI39si7gdDFDhYlXhbkocUvVMlzcA7nQQTBGXfp7B8PRSXAT1DK4HJfikLNxt0FbMrmgwaYpsPjJTJNuTytBW-nCqAPnGF_5jA'
    
    
    
      url = 'http://skreemr.com/results.jsp?q='+params[:track].split(' ').join('+')+'+'+params[:artist].split(' ').join('+')
    
      puts '********* [ contacting skreemr for the mp3s ]'
      page = Net::HTTP.get_response(URI.parse(url)).body
    
      puts '********* [ scraping skreemr response ]'
      start = page.index('soundFile')+9

      page = page[start..-1]
      ending = page.index("'>")-1
      page = page[1..ending]
      @source = CGI::unescape(page)

      puts '********* [ mp3 hosting server is : '+@source[7..-1].split('/').shift+']'
      puts '********* [ full mp3 file path : '+@source+']'
    
      puts '********* [ download mp3 file locally ]'
    
      @newsource = 'files/'+params[:track].split(' ').join('_')+'_'+params[:artist].split(' ').join('_')+'.mp3'
    
      Net::HTTP.start(@source[7..-1].split('/').shift) { |http|
        resp = http.get(@source)
        open(@newsource, "w") { |file|
            file.write(resp.body)
        }
      }
  
      puts '********* [ mp3 file downloaded ]'

      file = (rand*100000000).round.to_s+'.mov'

      @target = 'files/' + file
    
    
      puts '********* [ run ffmpeg to create new video ]'
      command = 'ffmpeg -i '+@newsource+' -ar 44100 -f image2 -i files/tuneful.jpg -loop_input -shortest -ab 512 -r 1 -b 100 -s 640x480 '+@target
      puts command
      #command.gsub!(/\s+/, " ")
    
      #exec command
    
      #exec command
      system command
    
      puts '********* [ ffmpeg complete ]'
      puts '********* [ upload to youtube ]'
      uploader = YouTubeG::Upload::VideoUpload.new(user, pass, developer_key)
      uploader.upload File.open(@target), :title=>@target.split('/').pop,:description=>@target,:category=>'People',:keywords=>%w[tuneful]
      puts '********* [ uploaded to youtube ]'
    
      if File.exist?(@source)
        File.delete(@source) 
      end
      if File.exist?(@target)    
        File.delete(@target)
      end
    
    end
    
    
    respond_to do |format|
      format.html
    end
  end
end
