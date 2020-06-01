require 'rails_helper'

RSpec.describe "Searches", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }

  def submit_micropost_1
    visit post_pages_path
    fill_in '記事の題名', with: 'トレーニングジム', match: :first
    fill_in 'サービスの金額を入力してください', with: '月額2500円', match: :first
    fill_in '記事の内容', with: 'このトレーニングジムにたくさんの器具がある！', match: :first
    attach_file 'micropost[picture]', "#{Rails.root}/db/images_seeds/1.png", match: :first
    click_button '投稿する'
  end

  def submit_micropost_2
    visit post_pages_path
    fill_in '記事の題名', with: 'アマゾンプライム', match: :first
    fill_in 'サービスの金額を入力してください', with: '月額500円', match: :first
    fill_in '記事の内容', with: '映画がたくさん見れる', match: :first
    attach_file 'micropost[picture]', "#{Rails.root}/db/images_seeds/1.png", match: :first
    click_button '投稿する'
  end

  before do
    login_system(user)
    submit_micropost_1
    submit_micropost_2
  end

  describe "検索に関するテスト" do
    it "記事の題名と内容がワードに含まれていたら検索結果として出る" do
      click_on '検索', match: :first
      fill_in 'search', with: 'トレーニングジム'
      click_button '検索'
      expect(page.body).to have_content "'トレーニングジム'の検索結果"
      expect(page.body).to have_content "記事名：トレーニングジム"
      expect(page.body).not_to have_content "記事名：アマゾンプライム"
    end

    it "記事の題名がワードに含まれていたら検索結果として出る" do
      click_on '検索', match: :first
      fill_in 'search', with: 'アマゾンプライム'
      click_button '検索'
      expect(page.body).to have_content "'アマゾンプライム'の検索結果"
      expect(page.body).not_to have_content "記事名：トレーニングジム"
      expect(page.body).to have_content "記事名：アマゾンプライム"
    end

    it "記事の内容にワードに含まれていたら検索結果として出る" do
      click_on '検索', match: :first
      fill_in 'search', with: '映画がたくさん見れる'
      click_button '検索'
      expect(page.body).to have_content "'映画がたくさん見れる'の検索結果"
      expect(page.body).not_to have_content "記事名：トレーニングジム"
      expect(page.body).to have_content "記事名：アマゾンプライム"
    end

    it "記事の題名、内容にワードに含まれていない場合は検索結果は出ない" do
      click_on '検索', match: :first
      fill_in 'search', with: ' '
      click_button '検索'
      expect(page.body).to have_content "''と一致する記事はありません。"
      expect(page.body).not_to have_content "記事名：トレーニングジム"
      expect(page.body).not_to have_content "記事名：アマゾンプライム"
    end

    it "ユーザー検索を行うと名前に該当するユーザーが出てくる" do
      login_system(other_user)
      visit users_path
      fill_in 'search', with: 'yamamoto', match: :first
      click_button '検索'
      expect(page.body).not_to have_content "ユーザー名：test"
      expect(page.body).to have_content "ユーザー名：yamamoto"
    end
  end
end
