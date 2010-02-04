require 'digest/sha1'

class User

  include MongoMapper::Document
  
  
  
  key :name, String
  key :password, String
  key :salt, String
  key :email, String
  key :invites_left, Integer, :default => 3
  key :notifications, Object
  key :unique_hash, String, :required => true
  
  
  
  
  many :stations
  many :invites
  #validates_length_of :name, :within => 3..40
  #validates_length_of :password, :within => 5..40
  #validates_presence_of :name, :email, :password, :password_confirmation, :salt
  #validates_uniqueness_of :hashed_password
  #validates_confirmation_of :password
  #validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  

  #attr_protected :id, :salt

  #attr_accessor :password, :password_confirmation

  def initialize(params = nil) 
     
     self.unique_hash = User.random_string(3)
     self.salt = User.random_string(3)
     
     super(params) 
     #@password = User.encrypt(self.password,self.salt)
     
     #self.password = self.write_password(params[:password])
     
     
     #self.save()
   end

  def self.authenticate(name, pass)
    u=first(:conditions=>{'name'=>name})
    
    #u=find(:first, :conditions=>["name = ?", name])
    return nil if u.nil?
    #return u if User.encrypt(pass, u.salt)==u.password
    return u if pass==u.password
    nil
  end  

  def password=(pass)
    #@password = pass
    puts '*************'
    @password = User.encrypt(pass,self.salt)
    @password = pass
    puts 'in password'
    puts @password
    puts '*************'
    #@password = pass
  end
  
  
  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.name, new_pass)
  end
  
  def self.register(params)
    self[:name]=params[:name]
    @pass=params[:password]
    @confirm=params[:confirm]
    @email=params[:email]
    
  end

  protected

  def self.encrypt(pass,salt)
    #puts self.salt
    
    pass+'999'+salt
    #Digest::SHA1.hexdigest(pass+'f9j3ah83hdks93jsha9sh3kfhs'+salt)
  end

  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

end