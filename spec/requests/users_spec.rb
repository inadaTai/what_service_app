require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:other_user) }

  def post_signup_invalid
    post signup_path, params: {
      user: {
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar",
      },
    }
  end

  def post_signup_valid
    post signup_path, params: {
      user: {
        name: "test",
        email: "test23@gmail.com",
        password: "foobar",
        password_confirmation: "foobar",
      },
    }
  end

  describe "GET /users" do
    it "未ログイン時ユーザー一覧ページへアクセスできない" do
      get users_path
      follow_redirect!
      expect(flash[:danger]).to be_truthy
      expect(request.fullpath).to eq '/login'
    end

    it "ログイン時ユーザー一覧ページへアクセス可能" do
      log_in_as(user)
      get users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /signup" do
    it "新規登録画面へアクセス可能" do
      get signup_path
      expect(response).to have_http_status(:success)
    end

    it "無効な新規登録情報を送信しユーザーを作成できない" do
      get signup_path
      expect { post_signup_invalid }.not_to change(User, :count)
    end

    it "有効な新規登録情報を送信しユーザーを作成する" do
      get signup_path
      expect { post_signup_valid }.to change(User, :count).by(1)
      follow_redirect!
      expect(request.fullpath).to eq "/users/3"
    end
  end
end
