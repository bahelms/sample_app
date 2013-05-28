class User < ActiveRecord::Base
	before_save { email.downcase! }
  before_save :create_remember_token  # Looks for that method
  
	validates :name,  presence: true, length: { maximum: 50 }
	VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i  
	validates :email, presence: true, 
										format: { with: VALID_EMAIL }, 
										uniqueness: { case_sensitive: false }

	has_secure_password  # Provides #authencate() method
	validates :password_confirmation, presence: true
	validates :password, length: { minimum: 6 }  # :presence added by line 8

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end