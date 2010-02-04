class Invite
  include MongoMapper::Document
  
  
  
  key :email, String, :required => true
  key :user_id, ObjectId, :required => true
  key :invited, DateTime
  
  
  belongs_to :user
  #validates_uniqueness_of :email
  
  def send_email
    self.invited = Time.now
    
    if self.save
      return true
    else
      return false
    end
  end
  
  
  
end
