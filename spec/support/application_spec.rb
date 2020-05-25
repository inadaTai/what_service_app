module ApplicationHelpers
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as
    get login_path
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password,
        remember_me: remember_me,
      },
    }
    follow_redirect!
  end

  def login_system(user)
    visit login_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_on 'What Service Appへログイン'
  end
end
