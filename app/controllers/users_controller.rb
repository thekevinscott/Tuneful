class UsersController < ApplicationController
  
  def invites
    
    @user = User.find_by_name(session[:name])
    puts '***********'
    if params[:invites]
      invites = params[:invites].split(',')
      puts invites
      puts '*** *** ***'
      if invites.length <= @user.invites_left
        invites.each do |email|
          i = Invite.new({:email=>email,:user_id=>@user.id})
          puts i
          i.save
        end
        @user.invites_left -= invites.length
        @user.save
        @obj = {'error'=>0}
      else
        @obj = {'error'=>3}
        
      end
    end
    
    
    @invites = @user.invites_left

    respond_to do |format|
      format.html { render :layout => false }
      format.js { render :json => @obj.to_json}
    end
  end
  
  def logout
    session[:name] = nil
    session[:logged_in] = nil
    respond_to do |format|
      format.html { redirect_to('/') }
    end
  end
  
  def save_email
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  
  def new
    respond_to do |format|
      format.html
      #format.xml  { render :xml => @station }
      format.js { render :json => @user.to_json }
      
    end
  end
  def login
    puts "SHIIIIIIIIIIIIIIIIIIT"
    @InterestedParty = InterestedParty.new
    @user = User.new

    @funny = ['Tuneful... is your father', 'Tuneful cuts a mean rug', 'Tuneful is gonna bake you a cake', 'Want some hot chocolate? Tough.', 'Tuneful can build you a train set', 'Tuneful feels for you', 'Tuneful likes coffee', 'Tuneful is your lover', 'Tuneful likes puppies', 'Tuneful is a helluva nice person'].rand
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
    puts "CREAAAAAAAAAAAAAAAAAAAAAAAAATE"
    @user = User.authenticate(params[:user][:name],params[:user][:password])
    puts '***********************'
    puts @user
    puts @user.nil?
    if @user.nil?
      puts 'it is false'
      #redirect_to('/login')
      respond_to do |format|
        format.html { render :action => 'login' }
      end
    else
      puts 'it is true'
      session[:logged_in] = true
      session[:name] = @user.name
      #session[:user_id] = @user.id
      #session[:user] = @user
      #redirect_to('/')
      respond_to do |format|
        format.html { redirect_to('/') }
      end      
    end
    #@user = User.new(params[:user])
    #@user.save()

  end
  
  def show 
  end
end
