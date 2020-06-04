require 'rails_helper'

RSpec.describe "ユーザの新規登録に関するテスト", type: :system do
  def submit_invalid
    fill_in 'ユーザーネーム(サイト内で公開されるお名前です) (例:hoge_175)', with: ''
    fill_in 'メールアドレス', with: 'user@invalid'
    fill_in 'パスワード', with: 'foo'
    fill_in 'もう１度パスワード入力してください', with: 'bar'
  end

  def submit_valid
    fill_in 'ユーザーネーム(サイト内で公開されるお名前です) (例:hoge_175)', with: 'realname'
    fill_in 'メールアドレス', with: 'user@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in 'もう１度パスワード入力してください', with: 'password'
  end

  it "無効な新規登録をした場合" do
    visit signup_path
    submit_invalid
    click_on 'アカウント登録'
    expect(current_path).to eq signup_path
    expect(page).to have_selector '#error_explanation'
  end

  it "有効な新規登録をした場合" do
    visit signup_path
    submit_valid
    click_on 'アカウント登録'
    expect(current_path).to eq user_path(4)
    expect(page).not_to have_selector '#error_explanation'
  end
end
