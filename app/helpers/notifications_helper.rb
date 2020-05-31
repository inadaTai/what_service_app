module NotificationsHelper
  def unchecked_notifications
    current_user.passive_notifications.where(checked: false)
  end

  def notification_form(notification)
    visiter = link_to notification.visiter.name, notification.visiter, style: "font-weight: bold;"
    your_post = link_to 'あなたの投稿', notification.micropost, style: "font-weight: bold;", local: true
    case notification.action
    when "follow"
      "#{visiter}があなたをフォローしました"
    when "like"
      "#{visiter}が#{your_post}にいいね！しました"
    when "comment" then
      Comment.find_by(id: notification.comment_id)&.body
      "#{visiter}が#{your_post}にコメントしました"
    end
  end
end
