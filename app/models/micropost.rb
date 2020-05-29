class Micropost < ApplicationRecord
  belongs_to :contributer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 2500 }
  validates :name, presence: true, length: { maximum: 30 }
  validates :price, presence: true, length: { maximum: 30 }
  has_one_attached :picture
  validate :picture_presence
  has_many :comments, dependent: :destroy

  def picture_presence
    if picture.attached?
      if !picture.content_type.in?(%('image/jpeg image/png'))
        errors.add(:picture, '添付にはjpegまたはpngファイルを添付してください')
      end
    else
      errors.add(:picture, 'を添付してください')
    end
  end

  def resize_picture
    picture.variant(resize: '400x400').processed
  end
end
