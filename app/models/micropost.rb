class Micropost < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 20000 }
  validates :name, presence: true, length: { maximum: 30 }
  validates :price, presence: true, length: { maximum: 30 }
end
