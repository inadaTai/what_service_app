class SessionsController < ApplicationController
  def new
  end

  def create
    auth = request.env['omniauth.auth']
    if auth.present?
      user = User.find_or_create_from_auth(request.env['omniauth.auth'])
      session[:user_id] = user.id
      redirect_back_or user
    else
      user = User.find_by(email: params[:session][:email])
      if user && user.authenticate(params[:session][:password])
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        flash[:success] = 'ログインしました！'
        redirect_back_or user
      else
        flash.now[:danger] = 'メールアドレスまたはパスワードが違います。'
        render 'new'
      end
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = 'ログアウトしました！'
    redirect_to root_url
  end
end
