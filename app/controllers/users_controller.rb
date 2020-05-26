class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "会員登録が完了しました！"
      redirect_to @user
    else
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
    flash[:success] = "アカウントの削除を実施しました"
    redirect_to users_url
  end

  private

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインが必要なページとなります。"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end
end
