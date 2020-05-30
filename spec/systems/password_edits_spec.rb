require 'rails_helper'

RSpec.describe "PasswordEdits", type: :system do
  let(:user) { create(:user) }
  let(:face_user) { create(:face_user) }
  let(:test_user) { create(:test_user) }

  def valid_patch
    fill_in '現在のパスワード', with: 'foobar'
    fill_in '新規パスワード', with: 'password'
    fill_in '確認の為もう一度ご入力ください', with: 'password'
    click_on '再設定'
  end

  describe "パスワード編集ページについてテスト" do
    it "通常のユーザーはパスワード編集できる" do
      login_system(user)
      visit "/password_edits/edit"
      valid_patch
      expect(page).to have_selector '.alert-success'
    end

    it "フェイスブックアカウントユーザーは編集不可" do
      login_system(face_user)
      visit "/password_edits/edit"
      expect(page).to have_content "かんたんログインユーザーまたはFacebookアカウントのユーザーはご利用できません"
    end

    it "かんたんログインユーザーは編集不可" do
      login_system(test_user)
      visit "/password_edits/edit"
      expect(page).to have_content "かんたんログインユーザーまたはFacebookアカウントのユーザーはご利用できません"
    end
  end
end
