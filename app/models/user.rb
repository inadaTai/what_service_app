class User < ApplicationRecord
  has_secure_password
  validates :password, length: { minimum: 6 }
  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.freeze
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost
    if BCrypt::Engine::MIN_COST
      BCrypt::Engine.cost
    else
      BCrypt::Password.create(string, cost: cost)
    end
  end
end
