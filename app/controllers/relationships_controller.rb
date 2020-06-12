class RelationshipsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @user = User.find(params[:followed_id])
    @user.create_notification_by(current_user)
    current_user.follow(@user)
    redirect_to @user
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    @user.delete_notification_by(current_user)
    current_user.unfollow(@user)
    redirect_to @user
  end
end
