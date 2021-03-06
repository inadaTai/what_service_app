require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:user) { create(:user) }

  def submit_valid_micropost
    visit post_pages_path
    fill_in '(※必須)記事の題名', with: '渋谷のフィットネスクラブ', match: :first
    fill_in '(※必須)サービスの金額を入力してください', with: '月額500円', match: :first
    find('trix-editor').click.set('良いサービス')
    attach_file 'micropost[picture]', "#{Rails.root}/db/images_seeds/1.png", match: :first
    click_button '投稿する'
  end

  def submit_valid_comment
    click_on '渋谷のフィットネスクラブ'
    fill_in "comment_body", with: 'a' * 140
    click_on 'コメント投稿'
    visit current_path
  end

  context "ログイン済み時の表示" do
    before do
      login_system(user)
      submit_valid_micropost
    end

    it "空欄で無効なコメントを行いエラーがメッセージが出る" do
      click_on '渋谷のフィットネスクラブ'
      click_on 'コメント投稿'
      expect(page).to have_selector '.alert-danger'
    end

    it "141文字以上の無効なコメントを行いエラーメッセージが出る" do
      click_on '渋谷のフィットネスクラブ'
      fill_in "comment_body", with: 'a' * 141
      click_on 'コメント投稿'
      expect(page).to have_selector '.alert-danger'
    end

    it "コメント投稿者は自分の投稿を削除できコメントのカウントも減る", js: true do
      submit_valid_comment
      click_on 'コメント削除'
      expect { visit current_path }.to change(user.comments, :count).by(-1)
    end

    it "有効なコメント投稿を行うとコメントのカウントも増える", js: true do
      expect { submit_valid_comment }.to change(user.comments, :count).by(1)
    end
  end

  context "未ログイン時の表示" do
    it "未ログインのユーザーはコメント入力欄がない" do
      login_system(user)
      submit_valid_micropost
      link = find('#picture_dropdown')
      link.click
      click_on 'ログアウト'
      click_on '渋谷のフィットネスクラブ'
      expect(page).not_to have_content "comment_body"
    end
  end
end
