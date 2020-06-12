class FavoriteRelationshipsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @user = current_user
    @micropost = Micropost.find(params[:micropost_id])
    current_user.like(@micropost)
    @micropost.create_notification_by(current_user)
    respond_to do |format|
      format.html { redirect_back_or root_url }
      format.js
    end
  end

  def destroy
    @user = current_user
    @micropost = FavoriteRelationship.find(params[:id]).micropost
    @micropost.delete_notification_by(current_user)
    current_user.unlike(@micropost)
    respond_to do |format|
      format.html { redirect_back_or root_url }
      format.js
    end
  end
end
