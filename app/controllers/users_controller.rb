class UsersController < ApplicationController
  def new
    respond_to do |format|
      format.html
      #format.xml  { render :xml => @station }
      format.js { render :json => @user.to_json }
      
    end
  end
  def login
    @InterestedParty = InterestedParty.new
    @user = User.new
    respond_to do |format|
      format.html
      format.js { render :json => @user.to_json }
      
    end    
  end
  
  def register
    
    respond_to do |format|
      format.html
      format.js { render :json => @user.to_json }
      
    end
  end
  
  def create
    @user = User.new(params[:user])
    #@user.save()
    respond_to do |format|
      #format.html { redirect_to('/') }
    end
  end
  
  def show 
  end
end
