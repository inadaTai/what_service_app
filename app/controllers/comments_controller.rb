class CommentsController < ApplicationController
  before_action :logged_in_user
  def create
    @micropost=Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      render :index
    else
      flash[:danger]="無効な操作が行われました。"
      redirect_to "/microposts/#{@micropost.id}"
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id])
    @comment.destroy
    render :index
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :micropost_id, :user_id)
  end
end
