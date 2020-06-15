require 'rails_helper'

RSpec.describe "ログインに関するテスト", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:test_user) { create(:test_user) }

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

    it "有効なログインをした場合ヘッダーのメニューが変わる" do
      visit root_path
      expect(page.body).to have_link 'ホーム'
      expect(page.body).to have_link 'アバウト'
      expect(page.body).to have_link 'ログイン'
      expect(page.body).not_to have_link '検索'
      expect(page.body).not_to have_link 'メニュー'
      expect(page.body).not_to have_css('#picture_dropdown')
      login_system(user)
      expect(page.body).to have_link '検索'
      expect(page.body).to have_link 'メニュー'
      link = find('#picture_dropdown')
      link.click
      expect(page.body).to have_link 'プロフィール'
      expect(page.body).to have_link '設定'
      expect(page.body).to have_button 'ログアウト'
    end

    it "有効なログイン後にログアウトできる" do
      login_system(user)
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector '.alert-success'
      link = find('#picture_dropdown')
      link.click
      click_on 'ログアウト'
      expect(current_path).to eq root_path
    end

    it "管理者アカウントのみ他人のアカウント削除が可能である", js: true do
      login_system(other_user)
      login_system(user)
      visit users_path
      click_on 'アカウント削除'
      expect(page.driver.browser.switch_to.alert.text).to eq "※メンテナンス日専用リンク！違反アカウントを削除する機能です、削除しますか？"
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector '.alert-success'
      expect(current_path).to eq root_path
    end
    # spaceを入れてしまうと確認メッセージでエラーが出るのでインデント崩しています
    it "有効なログイン後に退会ができる", js: true do
      login_system(user)
      expect(current_path).to eq user_path(1)
      expect(page).to have_selector '.alert-success'
      link = find('#picture_dropdown')
      link.click
      click_on '設定'
      click_on 'What Service Appを退会', match: :first
      expect(page.driver.browser.switch_to.alert.text).to eq "退会の手続きをされますと全てのサービスが利用不可となります、再度ご利用いただくには会員登録が必要となります。
本当に退会してよろしいですか?"
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector '.alert-success'
      expect(current_path).to eq root_path
    end

    it "かんたんログインユーザーはプロフィール編集と退会が不可" do
      visit root_path
      login_system(test_user)
      link = find('#picture_dropdown')
      link.click
      click_on '設定'
      expect(page).to have_content "かんたんログインユーザーは編集操作ができません"
      expect(page).to have_content "かんたんログインユーザーは退会できません"
    end
  end
end
