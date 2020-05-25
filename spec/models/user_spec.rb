require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "ユーザー名に関するテスト(nameカラム)" do
    it "有効なユーザーかテスト" do
      expect(user).to be_valid
    end

    it "空欄登録防止テスト" do
      user.name = "  "
      expect(user).to be_invalid
    end

    it "31文字以上は不可テスト" do
      user.name = "a" * 31
      expect(user).to be_invalid
    end

    it "31文字未満は可テスト" do
      user.name = "a" * 30
      expect(user).to be_valid
    end
  end

  describe "メールアドレスに関するテスト(emailカラム)" do
    it "空欄防止テスト" do
      user.email = "  "
      expect(user).to be_invalid
    end

    it "255文字以上は不可テスト" do
      user.email = "a" * 246 + "@example.com"
      expect(user).to be_invalid
    end

    it "255未満は可テスト" do
      user.email = "a" * 245 + "@gmail.com"
      expect(user).to be_valid
    end

    it "メールアドレスの一意性に関するテスト" do
      duplicate_user = user.dup
      duplicate_user.email = user.email.upcase
      user.save!
      expect(duplicate_user).to be_invalid
    end

    it "有効なメールアドレス一覧テスト" do
      user.email = "user@gmail.com"
      expect(user).to be_valid

      user.email = "user@yahoo.co.jp"
      expect(user).to be_valid

      user.email = "user+foo@example.co.jp"
      expect(user).to be_valid

      user.email = "User@exAmpLe.co.jp"
      expect(user).to be_valid
    end

    it "無効なメールアドレス一覧テスト" do
      user.email = "user@example,com"
      expect(user).to be_invalid

      user.email = "user_example_jp_com"
      expect(user).to be_invalid

      user.email = "user+example.jp_com"
      expect(user).to be_invalid

      user.email = "user@example..com"
      expect(user).to be_invalid

      user.email = "user@gmail+com.jp"
      expect(user).to be_invalid
    end
  end

  describe "パスワードに関するテスト(passwordカラム)" do
    it "空欄防止テスト" do
      user.password = user.password_confirmation = "  "
      expect(user).to be_invalid
    end

    it "5文字以下は不可テスト" do
      user.password = user.password_confirmation = "a" * 5
      expect(user).to be_invalid
    end

    it "6文字以上は可テスト" do
      user.password = user.password_confirmation = "a" * 6
      expect(user).to be_valid
    end
  end
end
