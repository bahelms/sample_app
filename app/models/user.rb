class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", 
                                   class_name: "Relationship", 
                                   dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower
  # This source is optional; :followers turns into follower_id
  has_many :replies, foreign_key: "reply_to_id", 
                     class_name: "Micropost",
                     dependent: :destroy

	before_save { email.downcase! }
  before_save :create_remember_token  # Looks for that method
  
	validates :name,  presence: true, 
                    length: { maximum: 50 },
                    uniqueness: { case_sensitive: false }
	VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i  
	validates :email, presence: true, 
										format: { with: VALID_EMAIL }, 
										uniqueness: { case_sensitive: false }

	has_secure_password  # Provides #authencate() method
	validates :password_confirmation, presence: true
	validates :password, length: { minimum: 6 }  # :presence added by line 8

  def feed
    # Micropost.where("user_id = ?", id)  # ? escapes the id var, avoiding SQL injection
    Micropost.from_users_followed_by_including_replies(self)
  end

  def following?(other_user)
    relationships.find_by(followed_id: other_user.id)    
  end

  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end