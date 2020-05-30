class PasswordEditsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]

  def show
    redirect_to password_edit_path
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user&.authenticate(params[:user][:current_password])
      if @user.update(password_params) && @user.password.present?
        flash[:success] = "パスワードを更新しました"
        redirect_to @user
      else
        flash.now[:danger] = "無効な送信です"
        render 'edit'
      end
    else
      @user.errors.add(:current_password, :wrong)
      render 'edit'
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
