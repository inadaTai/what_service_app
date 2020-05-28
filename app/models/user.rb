class User < ApplicationRecord
  attr_accessor :remember_token
  has_secure_password
  validates :password, length: { minimum: 6 }, confirmation: true,
                       allow_nil: true
  validates :name, presence: true, length: { maximum: 30 }
  validates :introduct, length: { maximum: 300 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_many :microposts, dependent: :destroy
  has_one_attached :picture, dependent: :destroy

  def feed
    Micropost.all
  end

  def resize_icon
    picture.variant(resize: '50x50').processed
  end

  def resize_edit_icon
    picture.variant(resize: '80x80').processed
  end

  def resize_home_icon
    picture.variant(resize: '65x65').processed
  end

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
end
