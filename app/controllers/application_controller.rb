class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
  
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインが必要なページとなります。"
      redirect_to login_url
    end
  end

  def correct_user
    @user = User.find(params[:id])
    if @user == current_user || current_user.admin?
    else
      redirect_to(root_url)
    end
  end
end
