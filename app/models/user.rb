require 'digest/sha1'

class User < ActiveRecord::Base
  has_and_belongs_to_many :stations
  validates_length_of :name, :within => 3..40
  validates_length_of :password, :within => 5..40
  #validates_presence_of :name, :email, :password, :password_confirmation, :salt
  #validates_uniqueness_of :hashed_password
  validates_confirmation_of :password
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  

  attr_protected :id, :salt

  attr_accessor :password, :password_confirmation

  def initialize(params = nil) 
     super(params) 
     self.unique_hash = User.random_string(32)
     self.hashed_password = User.random_string(32)
     
     self.save()
   end

  def self.authenticate(name, pass)
    u=find(:first, :conditions=>["name = ?", name])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt)==u.hashed_password
    nil
  end  

  def password=(pass)
    @password=pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)
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

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

end