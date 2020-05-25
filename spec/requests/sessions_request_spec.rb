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

  def post_valid_information
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password,
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
      post_valid_information
      expect(is_logged_in?).to be_truthy
      delete logout_path
      expect(is_logged_in?).to be_falsey
    end
  end
end
