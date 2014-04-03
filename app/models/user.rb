class User < ActiveRecord::Base

  has_secure_password

  before_save { self.email = email.downcase }
  before_create { generate_remember_token(:remember_token) }

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

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

  def self.authenticate_user(email, password)
    user = find_by_email(email)
    if user && user.authenticate(password)
      user if user.email_confirmed
    end
  end

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
