require 'rails_helper'

RSpec.describe "PasswordEdits", type: :request do
  let(:user) { create(:user) }

  def patch_invalid
    patch password_edits_edit_path(user), params: {
      user: {
        current_password: "",
        password: "foobar21",
        password_confirmation: "foobar21",
      },
    }
  end

  def patch_valid
    patch password_edits_edit_path(user), params: {
      user: {
        current_password: "foobar",
        password: "password",
        password_confirmation: "password",
      },
    }
  end

  describe "GET /password_edits/edit" do
    it "ログインユーザーはパスワードエディットページにアクセス可能" do
      log_in_as(user)
      get "/password_edits/edit"
      expect(response).to have_http_status(:success)
    end

    it "未ログインユーザーはパスワードエディットページにアクセスできない" do
      get "/password_edits/edit"
      follow_redirect!
      expect(request.fullpath).to eq login_path
    end

    context "パスワード変更に関するテスト" do
      it "無効なパスワード変更リクエストのテスト" do
        log_in_as(user)
        get password_edits_edit_path(user)
        patch_invalid
        expect(request.fullpath).to eq '/password_edits/edit.1'
      end

      it "有効なパスワード変更リクエストのテスト" do
        log_in_as(user)
        get password_edits_edit_path(user)
        patch_valid
        expect(flash[:success]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/users/1'
      end
    end
  end
end
