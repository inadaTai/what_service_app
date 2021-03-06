class User < ApplicationRecord
  attr_accessor :remember_token
  attr_accessor :current_password
  has_secure_password validations: false
  validates :password, length: { minimum: 6 }, unless: :uid?, confirmation: true,
                       allow_nil: true
  validates :name, presence: true, unless: :uid?, length: { maximum: 30 }
  validates :introduct, length: { maximum: 160 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, unless: :uid?, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_many :microposts, dependent: :destroy
  has_one_attached :picture, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments, dependent: :destroy
  has_many :favorite_relationships, dependent: :destroy
  has_many :likes, through: :favorite_relationships, source: :micropost
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    Micropost.all
  end

  def resize_icon
    picture.variant(resize: '50x50').processed
  end

  def resize_follow_icon
    picture.variant(resize: '35x35').processed
  end

  def resize_edit_icon
    picture.variant(resize: '80x80').processed
  end

  def resize_home_icon
    picture.variant(resize: '65x65').processed
  end
  # rubocop:disable all
  def follower_feed
    following_ids = "SELECT followed_id FROM relationships
    WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
    OR user_id = :user_id", user_id: id)
  end

  # rubocop:enable all

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def self.find_or_create_from_auth(auth)
    provider = auth[:provider]
    uid = auth[:uid]
    name = auth[:info][:name]
    find_or_create_by(provider: provider, uid: uid) do |user|
      user.name = name
    end
  end

  def like(micropost)
    likes << micropost
  end

  def unlike(micropost)
    favorite_relationships.find_by(micropost_id: micropost.id).destroy
  end

  def likes?(micropost)
    likes.include?(micropost)
  end

  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(
      visited_id: id,
      action: "follow"
    )
    notification.save if notification.valid?
  end

  def delete_notification_by(current_user)
    notification = current_user.active_notifications.find_by(
      visited_id: id,
      action: "follow"
    )
    notification.destroy if !notification.nil?
  end

  def self.search(search)
    if search
      where(['name LIKE ?', "%#{search}%"])
    else
      all
    end
  end
end
