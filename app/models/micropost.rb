class Micropost < ActiveRecord::Base
  belongs_to :user
  before_save :reply_to_user
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  def self.from_users_followed_by_including_replies(user)
    # followed_user_ids == user.followed_users.map(&:id)  (.map { |user| user.id} )
    # where("user_id IN (?) OR user_id = ?", followed_user_ids, user)    # ? escapes the var, avoiding SQL injection

    # SQL subselect is more efficient
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id 
           OR reply_to_id = :user_id", user_id: user)
  end

  private
    def reply_to_user
      if match = content.match(/\A@(\w+)/i)
        other_user = User.where(["lower(name) = ?", match[1].downcase]).first
        self.reply_to_id = other_user.id if other_user
      end
    end
end
