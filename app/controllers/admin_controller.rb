class AdminController < ApplicationController

  require 'rubygems'  
  require 'youtube_g'

  before_filter :require_kscott

  require 'rubygems'  
  require 'youtube_g'
  

  def require_kscott
    
    if session[:logged_in]
      if session[:name]!='t'
        redirect_to('/')
      end
    else
      redirect_to('/')      
    end

    #rescue ActiveRecord::RecordNotFound
  end
  
  def invites
    if params[:invite_id]
      puts '**********      **********'
      i = Invite.find(params[:invite_id])

      if i.send_email()
        @obj = {'error'=>0,'invited'=>i.invited}
      else
        @obj = {'error'=>1}
      end
    end
    
      
    @invites = Invite.all

    respond_to do |format|
      format.html { render :layout => "admin" }
      format.js { render :json => @obj.to_json}
    end
  end
    
  def index
    respond_to do |format|
      format.html
    end
  end
  
  
  
  
  def tracks
    @tracks = Track.all
    puts '***'
    if params[:id] == 'update_all'
      puts '*******'
      # run all unprocessed files
      @tracks = Track.all(:conditions=>{'youtubed'=>false})
      @tracks.each do |t|
        t.upload
      end
      
      
    end
    puts params[:id]

    respond_to do |format|
      format.html { render :layout => "admin" }
      format.js { }
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
