class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  include NotificationsHelper
  @@action_name = "comment" # rubocop:disable all

  def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      @comment.create_notification_by(current_user)
      respond_to do |format|
        format.html { redirect_back_or @micropost }
        format.js { render :index }
      end
    else
      flash[:danger] = "空欄または140文字以上のコメントは出来ません"
      redirect_to "/microposts/#{@micropost.id}"
    end
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy
    @comment.delete_notification_by(current_user)
    respond_to do |format|
      format.html { redirect_back_or @micropost }
      format.js { render :index }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :micropost_id, :user_id)
  end
end
