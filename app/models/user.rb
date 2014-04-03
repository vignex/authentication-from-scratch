class User < ActiveRecord::Base
	#This takes care of authentication and verification
  has_secure_password
	
	#Downcase Email before saving,Just in case
	before_save { self.email = email.downcase }
  before_create { generate_remember_token(:remember_token) }
	
	#Regular Expression to validate Email
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
  #Change these as per your requirement
  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, format: { with: EMAIL_REGEX },
		uniqueness: true, length: { minimum: 6 }
  validates :phone, presence: true, length: { maximum: 50 }
  validates :password, length: { minimum: 6 }	

	def self.authenticate_user(email, password)
	  user = find_by_email(email)
	  if user && user.authenticate(password)
	     user
	  else
	     nil
	  end
	end  

  #Along with email and password also check whether email is confirmed    
  def self.authenticate_user(email, password)
    user = find_by_email(email)
    if user && user.authenticate(password)
     user if user.email_confirmed
    end
  end

  #Generate a base64 token using SecureRandom.urlsafe_base64 and update the time the email is sent.
  #Since we will be implementing password reset we can use the same fields for confirmation too. 
  #:password_reset_token and :password_sent_at
  def send_confirmation
    self.update_column(:password_reset_token, SecureRandom.urlsafe_base64)
    self.update_column(:password_sent_at, Time.zone.now)
    UserMailer.send_confirmation_mail(self).deliver
  end

  def generate_remember_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

end
