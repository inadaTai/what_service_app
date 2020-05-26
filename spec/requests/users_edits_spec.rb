require 'rails_helper'

RSpec.describe "Usersプロフィール編集に関するテスト", type: :request do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  def patch_invalid
    patch user_path(user), params: {
      user: {
        name: "",
        email: "test@invalid",
      },
    }
  end

  def patch_valid
    patch user_path(user), params: {
      user: {
        name: "yamada_516",
        email: "test@invalid.com",
      },
    }
  end

  describe "GET /users/:id/edit" do
    context "アクセス関係のテスト" do
      it "他ユーザーから編集ページにアクセス出来ない" do
        log_in_as(other_user)
        get edit_user_path(user)
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end

      it "未ログイン時は編集ページにアクセスできない" do
        get edit_user_path(user)
        follow_redirect!
        expect(request.fullpath).to eq '/login'
        log_in_as(user)
        expect(request.fullpath).to eq '/users/1/edit'
      end
    end

    context "無効な編集内容" do
      it "無効な編集内容でパッチリクエストした場合" do
        log_in_as(user)
        expect(is_logged_in?).to be_truthy
        get edit_user_path(user)
        expect(request.fullpath).to eq '/users/1/edit'
        patch_invalid
        expect(request.fullpath).to eq '/users/1'
      end
    end

    context "有効な編集内容" do
      it "有効な編集内容でパッチリクエストした場合" do
        log_in_as(user)
        get edit_user_path(user)
        patch_valid
        expect(flash[:success]).to be_truthy
        follow_redirect!
        expect(request.fullpath).to eq '/users/1'
      end

      it "他ユーザより有効なパッチリクエストを送られた時root_pathへアクセスとなる" do
        log_in_as(other_user)
        get edit_user_path(user)
        patch_valid
        follow_redirect!
        expect(request.fullpath).to eq '/'
      end
    end
  end
end
