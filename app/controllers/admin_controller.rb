class AdminController < ApplicationController

  require 'rubygems'  
  require 'youtube_g'
    
  def index
  end
  def tracks
    @tracks = Track.find(:all, :conditions => ['verified = ? ', 0])
    respond_to do |format|
      format.html
    end
  end
  def verify
    @track = Track.find(params[:id])
    @track.verified = 1
    if params[:file]
      
    	client = YouTubeG::Client.new
  		
      @file = params[:file].split('?').pop.split('=').pop
      @track.file = @file
      @track.duration = client.video_by(@file).duration
    end
    @track.save()
    @error = 0
    respond_to do |format|
      format.html
    end
  end
end
