class Micropost < ApplicationRecord
  belongs_to :contributer, class_name: 'User', foreign_key: 'user_id'
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 2500 }
  has_rich_text :content
  validates :name, presence: true, length: { maximum: 30 }
  validates :price, presence: true, length: { maximum: 30 }
  has_one_attached :picture, dependent: :destroy
  validate :picture_presence
  validate :picture_size
  has_many :comments, dependent: :destroy
  has_many :favorite_relationships, dependent: :destroy
  has_many :liked_by, through: :favorite_relationships, source: :user
  has_many :notifications, dependent: :destroy

  def picture_presence
    if picture.attached?
      if !picture.content_type.in?(%('image/jpeg image/png'))
        errors.add(:picture, '添付にはjpegまたはpngファイルを添付してください')
      end
    else
      errors.add(:picture, 'を添付してください')
    end
  end

  def picture_size
    if picture.attached?
      if picture.blob.byte_size > 5.megabytes
        errors.add(:picture, 'で5MBを超える画像データは添付が出来ません。')
      end
    end
  end

  def resize_picture
    picture.variant(resize: '400x400').processed
  end

  def modal_picture
    picture.variant(resize: '590x590').processed
  end

  def likes?(micropost)
    likes.include?(micropost)
  end

  def like(micropost)
    likes << micropost
  end

  def unlike(micropost)
    favorite_relationships.find_by(micropost_id: micropost.id).destroy
  end

  def create_notification_by(current_user)
    @notification = current_user.active_notifications.new(
      micropost_id: id,
      visited_id: contributer.id,
      action: "like"
    )
    @notification.save if @notification.valid?
  end

  def delete_notification_by(current_user)
    @notification = current_user.active_notifications.find_by(
      micropost_id: id,
      visited_id: contributer.id,
      action: "like"
    )
    @notification.destroy if !@notification.nil?
  end
end
