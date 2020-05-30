class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc).paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.password.present? && @user.save
      log_in @user
      flash[:success] = "会員登録が完了しました！"
      redirect_to @user
    else
      flash.now[:danger] = "無効な入力があります。"
      render 'new'
    end
  end

  def edit
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールの更新完了しました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "What Service Appを退会しました"
    redirect_to root_url
  end

  def following
    @title = "following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                 :introduct, :picture)
  end
end
