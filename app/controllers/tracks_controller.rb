class TracksController < ApplicationController
  def upload
    require 'net/http'
    require 'cgi'
    require 'youtube_g'
    
    
    
    user = 'tunefulapp'
    pass = '$!tuneful$!'
    developer_key = 'AI39si7gdDFDhYlXhbkocUvVMlzcA7nQQTBGXfp7B8PRSXAT1DK4HJfikLNxt0FbMrmgwaYpsPjJTJNuTytBW-nCqAPnGF_5jA'
    
    url = 'http://skreemr.com/results.jsp?q='+params[:track].split(' ').join('+')+'+'+params[:artist].split(' ').join('+')
    
    page = Net::HTTP.get_response(URI.parse(url)).body
    start = page.index('soundFile')+9

    page = page[start..-1]
    ending = page.index("'>")-1
    page = page[1..ending]
    @source = CGI::unescape(page)
    
    puts '************************'
    puts 'http://'+@source[7..-1].split('/').shift
    
    Net::HTTP.start(@source[7..-1].split('/').shift) { |http|
      resp = http.get(@source)
      open('files/'+@source.split('/').pop, "w") { |file|
          file.write(resp.body)
      }
    }
  

    file = (rand*100000000).round.to_s+'.mov'

    @target = 'files/' + file
    
    @source = 'files/' + @source.split('/').pop
    
    command = 'ffmpeg -i '+@source+' -ar 44100 -f image2 -i files/tuneful.jpg -loop_input -shortest -ab 512 -r 1 -b 100 -s 320x240 '+@target
    puts command
    #command.gsub!(/\s+/, " ")
    
    #exec command
    
    #exec command
    system command
    

    uploader = YouTubeG::Upload::VideoUpload.new(user, pass, developer_key)
    uploader.upload File.open(@target), :title=>'test',:description=>"cool",:category=>'People',:keywords=>%w[cool]

    
    respond_to do |format|
      format.html
    end
  end
end
