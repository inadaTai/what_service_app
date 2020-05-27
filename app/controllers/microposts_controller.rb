class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  def show
    @micropost = Micropost.find(params[:id])
    @user = User.find_by(id: @micropost.user_id)
  end

  def create
    @micropost = current_user.microposts.build(post_params)
    if @micropost.save
      flash[:success] = "記事を投稿しました！"
      redirect_to root_url
    else
      @feed_items = []
      render 'home_pages/post_pages'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "記事を削除しました"
    redirect_to root_url
  end

  def edit
    @micropost = Micropost.find(params[:id])
  end

  def update
    @micropost = Micropost.find(params[:id])
    if @micropost.update_attributes(post_params)
      flash[:success] = "記事の更新完了しました"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  private

  def post_params
    params.require(:micropost).permit(:name, :price, :content)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end

end
