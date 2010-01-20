class StationsController < ApplicationController
  #before_filter :require_user
  require 'youtube'


  def require_user
    redirect_to('/login')
    #  unless session[:user_id].blank?
    #    @logged_user = User.find(session[:user_id])
    #  end

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
      a = Artist.new({:title=>params[:artist]})
      a.save()
      #t = a.tracks.new({:title=>params[:track]}).save()
      @track = a.tracks.new({:title=>params[:track]})
      @track.save();
      @station.tracks.push(@track)
      @error = 0
    end
    # if we pass in parameters then we do one thing; otherwise the other
    respond_to do |format|
      format.js  {render (:layout => false,:partial=>'add_song') }
      format.html { redirect_to('/') }
    end
  end
  
  def index
    videos = YouTube::Client.new.videos_by(:query => "penguin")
    
    @stations = Station.all
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
      format.js {  } 
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
  
  
  
end
