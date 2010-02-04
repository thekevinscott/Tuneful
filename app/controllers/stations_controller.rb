class StationsController < ApplicationController
  before_filter :require_user

  require 'rubygems'  
  require 'youtube_g'
  

  def require_user
    
    if session[:logged_in]
      @user = User.find_by_name(session[:name])
      puts 'were logged in'
    else
      redirect_to('/login')      
    end

    #rescue ActiveRecord::RecordNotFound
  end


  def find_song
    @station = Station.find_by_url(params[:url])
    # if we pass in parameters then we do one thing; otherwise the other
    respond_to do |format|
      format.html
    end
  end
  
  def add_song
    @station = Station.find_by_url(params[:url])
    if (! params[:track])
      @error = 'You must provide a track'
    elsif (! params[:artist])
      @error = 'You must provide an artist'
    else
  		#client = YouTubeG::Client.new
  		#@media = client.videos_by(:query => params[:track]+' '+params[:artist]).videos[0].media_content[0]
    	#@media_url = @media.url.split('?').shift.split('/').pop
    	a = Artist.find_by_title(params[:artist])
    	if a.nil?
        a = Artist.new({:title=>params[:artist]})
        a.save()
  	  end

      #t = a.tracks.new({:title=>params[:track]}).save()
      #@track = a.tracks.new({:title=>params[:track],:file=>@media_url,:duration=>@media.duration})
      track = Track.new({:title=>params[:track],:artist=>a})
      #@track = a.tracks.new({:title=>params[:track]})
      track.save();
      @station.tracks.push(track)
      @error = 0
      #puts '*****************'
      #puts '***** wes gonna spawn a process'
      #spawn do # SPAWN DOES NOT WORK WITH MONGO
        #puts '*****************'
        #puts '***** spawn a process!'
        #track.upload(params[:track],params[:artist])
      #end
      #puts '*****************'
      #puts '***** wes done spawned a process'
    end
    # if we pass in parameters then we do one thing; otherwise the other
    respond_to do |format|
      format.js  {render(:layout => false,:partial=>'add_song') }
      format.html { redirect_to('/') }
    end
  end
  
  def index
    puts '********* stations *******'
    
    @stations = Station.all
    @playlist = Station.first.get_playlist
    
    @greeting = ['Hiya','Hola','Hey there','Ahoy','Sup','Yo'].rand
    
    if @user.notifications.length > 0
      @notif = @user.notifications.first
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @stations }
    end
  end

  # GET /stations/1
  # GET /stations/1.xml
  def show
    @station = Station.find_by_url(params[:url])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @station }

    end
  end

  # GET /stations/new
  # GET /stations/new.xml
  def new
    @station = Station.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @station }
    end
  end

  # GET /stations/1/edit
  def edit
    @station = Station.find(params[:id])
  end

  # POST /stations
  # POST /stations.xml
  def create
    @station = Station.new(params[:station])

    respond_to do |format|
      if @station.save
        flash[:notice] = 'Station was successfully created.'
        format.html { redirect_to(@station) }
        format.xml  { render :xml => @station, :status => :created, :location => @station }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @station.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /stations/1
  # PUT /stations/1.xml
  def update
    @station = Station.find(params[:id])

    respond_to do |format|
      if @station.update_attributes(params[:station])
        flash[:notice] = 'Station was successfully updated.'
        format.html { redirect_to(@station) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @station.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /stations/1
  # DELETE /stations/1.xml
  def destroy
    @station = Station.find(params[:id])
    @station.destroy

    respond_to do |format|
      format.html { redirect_to(stations_url) }
      format.xml  { head :ok }
    end
  end
  
  
  
  
  def subscribe
    @station = Station.find_by_url(params[:url])
    format.html { redirect_to(@station) }
  end
  def listen
    @station = Station.find_by_url(params[:url])
    format.html { redirect_to(@station) }
  end
  
  def playlist
    @playlist = Station.first.get_playlist
    respond_to do |format|
      format.html
    end
  end
  
  
end
