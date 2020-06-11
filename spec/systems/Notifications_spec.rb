require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  def valid_post
    visit post_pages_path
    fill_in '記事の題名', with: 'フィットネスクラブ', match: :first
    fill_in 'サービスの金額を入力してください', with: '月額500円', match: :first
    find('trix-editor').click.set('良いサービス')
    attach_file 'micropost[picture]', "#{Rails.root}/db/images_seeds/1.png", match: :first
    click_button '投稿する'
  end

  def valid_follow
    visit '/users/1'
    click_on 'フォロー'
    visit current_path
  end

  def valid_like
    visit micropost_path(1)
    click_on '0'
  end

  def valid_comment
    visit micropost_path(1)
    fill_in "comment_body", with: 'test投稿します'
    click_on 'コメント投稿'
  end

  describe "通知に関するテスト" do
    before do
      login_system(user)
      valid_post
    end

    it "他人ユーザーからフォローされたら有効な通知が来ている" do
      login_system(other_user)
      valid_follow
      login_system(user)
      visit notifications_path
      expect(page.body).to have_content 'yamamotoがあなたをフォローしました'
    end

    it "いいねされたら有効な通知が来ている" do
      login_system(other_user)
      valid_like
      login_system(user)
      visit notifications_path
      expect(page.body).to have_content 'yamamotoがあなたの投稿にいいね！しました'
    end

    it "自分の投稿へコメントを行い有効な通知が通知欄に来ている", js: true do
      valid_comment
      visit notifications_path
      expect(page.body).to have_content 'testがあなたの投稿にコメントしました'
    end

    it "未読通知はメニュー欄のところに件数つきで表示されいる" do
      login_system(other_user)
      valid_follow
      login_system(user)
      visit root_path
      expect(page.body).to have_content '未読通知を見にいく(1件)'
    end
  end
end
