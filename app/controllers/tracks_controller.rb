class TracksController < ApplicationController
  
  
  def require_kscott
    
    if session[:logged_in]
      if session[:name]!='t'
        redirect_to('/')
      end
    else
      redirect_to('/')      
    end

  end
  
  def find_files
    require_kscott
    @tracks = Track.all(:conditions=>{'youtubed'=>false})
    @tracks.each do |t|
      t.upload
    end
    
    @obj = {}
    
    respond_to do |format|
      format.html { render :json => @obj.to_json}
    end
  end
end
