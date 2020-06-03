require 'rails_helper'

RSpec.describe "FavoriteRelationships", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:user_post) { create(:micropost, contributer: user) }

  def submit_valid_micropost
    visit post_pages_path
    fill_in '記事の題名', with: 'フィットネスクラブ', match: :first
    fill_in 'サービスの金額を入力してください', with: '月額500円', match: :first
    fill_in '記事の内容', with: '良いサービス', match: :first
    attach_file 'micropost[picture]', "#{Rails.root}/db/images_seeds/1.png", match: :first
    click_button '投稿する'
  end

  # いいねボタンは[0]という名前で扱っております(カウントが増える場合のテスト)
  def submit_valid_likes
    visit micropost_path(1)
    click_button '0'
    visit current_path
  end

  # いいねボタンは[1]という名前で扱っております(カウントが減る場合のテスト)
  def submit_valid_unlikes
    visit micropost_path(1)
    click_button '1'
    visit current_path
  end

  before do
    login_system(user)
    submit_valid_micropost
  end

  it "他人の投稿にいいねを行いカウントが増えているか確認のテスト" do
    login_system(other_user)
    expect { submit_valid_likes }.to change(other_user.likes, :count).by(1)
  end

  it "他人の投稿にいいねを行いカウントが減るか確認のテスト" do
    login_system(other_user)
    submit_valid_likes
    expect { submit_valid_unlikes }.to change(other_user.likes, :count).by(-1)
  end

  # いいねボタンは[0]という名前で扱っております
  it "自分の投稿に対していいねボタンが無いことを確認のテスト" do
    visit micropost_path(1)
    expect(page).not_to have_button '0'
  end
end
