require 'rails_helper'

RSpec.describe "Users", type: :request do
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
        email: "test@gmail.com",
        password: "foobar",
        password_confirmation: "foobar",
        id: "1",
      },
    }
  end

  describe "GET /signup" do
    it "新規登録画面へアクセスできるかテスト" do
      get signup_path
      expect(response).to have_http_status(:success)
    end

    it "無効な新規登録情報テスト" do
      get signup_path
      expect { post_signup_invalid }.not_to change(User, :count)
    end

    it "有効な新規登録情報テスト" do
      get signup_path
      expect { post_signup_valid }.to change(User, :count).by(1)
      follow_redirect!
      expect(request.fullpath).to eq '/users/1'
    end
  end
end
