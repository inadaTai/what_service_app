class NotificationsController < ApplicationController
  before_action :logged_in_user, only: [:index]

  def index
    @notifications = current_user.passive_notifications.paginate(page: params[:page]).
      order(created_at: :desc).paginate(page: params[:page])
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
