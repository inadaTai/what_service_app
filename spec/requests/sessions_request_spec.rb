require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  include SessionsHelper

  let(:user) { create(:user) }

  def post_invalid_infomation
    post login_path, params: {
      session: {
        email: "",
        password: "",
      },
    }
  end

  def post_valid_information(remember_me = 0) # rubocop:disable all
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password,
        remember_me: remember_me,
      },
    }
  end

  describe "GET /login" do
    it "ログインページにアクセス可能" do
      get login_path
      expect(response).to have_http_status(:success)
    end

    it "有効なログイン後ログアウトする" do
      get login_path
      post_valid_information(0)
      expect(is_logged_in?).to be_truthy
      delete logout_path
      expect(is_logged_in?).to be_falsey
    end
  end

  describe "記憶トークン(remember_token)に関するテスト" do
    it "2回ログアウトができないか確認" do
      get login_path
      post_valid_information(0)
      expect(is_logged_in?).to be_truthy
      follow_redirect!
      expect(request.fullpath).to eq '/users/1'
      delete logout_path
      expect(is_logged_in?).to be_falsey
      follow_redirect!
      expect(request.fullpath).to eq '/'
      delete logout_path
      expect(is_logged_in?).to be_falsey
      follow_redirect!
      expect(request.fullpath).to eq '/'
    end
    
    it "記憶トークンを利用してログインが出来ているか確認" do
      get login_path
      post_valid_information(1)
      expect(is_logged_in?).to be_truthy
      expect(cookies[:remember_token]).not_to be_nil
    end

    it "記憶トークンを使用しログインしてログアウトした場合記憶トークンは空である" do
      get login_path
      post_valid_information(1)
      expect(is_logged_in?).to be_truthy
      expect(cookies[:remember_token]).not_to be_empty
      delete logout_path
      expect(is_logged_in?).to be_falsey
      expect(cookies[:remember_token]).to be_empty
    end
  end
end
