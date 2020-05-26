require 'rails_helper'

RSpec.describe "ログインに関するテスト", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  def submit_invalid
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    click_on 'What Service Appへログイン'
  end

  context "ログイン失敗時のメッセージに関するテスト" do
    it "無効なログイン情報を渡した場合エラー表記が出ている" do
      visit login_path
      submit_invalid
      expect(current_path).to eq login_path
      expect(page).to have_selector '.alert-danger'
    end

    it "無効なログイン情報を渡しエラー表記がログインページのみ出ている" do
      visit login_path
      submit_invalid
      expect(current_path).to eq login_path
      expect(page).to have_selector '.alert-danger'
      visit root_path
      expect(page).not_to have_selector '.alert-danger'
    end
  end

  context "有効なログイン時のメッセージに関するテスト" do
    it "有効なログイン情報を渡した場合成功の表記が出ている" do
      login_system(user)
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector '.alert-success'
    end

    it "有効なログイン後にログアウトできる" do
      login_system(user)
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector '.alert-success'
      click_on 'アカウント'
      click_on 'ログアウト'
      expect(current_path).to eq root_path
    end

    it "管理者アカウントのみ他人のアカウント削除が可能である" do
      login_system(other_user)
      login_system(user)
      visit users_path
      click_on 'アカウント削除'
      expect(page.driver.browser.switch_to.alert.text).to eq "※メンテナンス日専用リンク！違反アカウントを削除する機能です、削除しますか？"
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector '.alert-success'
      expect(current_path).to eq root_path
    end

    it "有効なログイン後に退会ができる" do
      login_system(user)
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector '.alert-success'
      click_on 'アカウント'
      click_on '設定'
      click_on 'What Service Appを退会', match: :first
      expect(page.driver.browser.switch_to.alert.text).to eq "退会の手続きをされますと全てのサービスが利用不可となります、再度ご利用いただくには会員登録が必要となります。
本当に退会してよろしいですか?"
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector '.alert-success'
      expect(current_path).to eq root_path
    end
  end
end
