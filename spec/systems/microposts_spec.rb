require 'rails_helper'

RSpec.describe "Microposts", type: :system do
  let(:user) { create(:user) }

  def submit_valid_micropost
    fill_in '(※必須)記事の題名', with: '渋谷のフィットネスクラブ', match: :first
    fill_in '(※必須)サービスの金額を入力してください', with: '月額500円', match: :first
    find('trix-editor').click.set('良いサービス')
    attach_file 'micropost[picture]', "#{Rails.root}/db/images_seeds/1.png", match: :first
    click_button '投稿する'
  end

  def submit_invalid_micropost
    fill_in '(※必須)記事の題名', with: 'サービス題名', match: :first
    fill_in '(※必須)サービスの金額を入力してください', with: '月額500円', match: :first
    find('trix-editor').click.set('a' * 2501)
    attach_file 'micropost[picture]', "#{Rails.root}/db/images_seeds/1.png", match: :first
    click_button '投稿する'
  end

  context "有効な投稿一覧" do
    before do
      login_system(user)
      visit post_pages_path
    end

    it "有効な投稿をした場合成功したメッセージが出ている" do
      submit_valid_micropost
      expect(current_path).to eq root_path
      expect(page).to have_selector '.alert-success'
    end

    it "有効な投稿後カテゴリ別ページで記事が表示される" do
      submit_valid_micropost
      visit fitness_path
      expect(page.body).to have_link '渋谷のフィットネスクラブ'
    end

    it "有効な投稿後カテゴリが違うものは記事が表示されない" do
      submit_valid_micropost
      visit school_path
      expect(page.body).not_to have_link '渋谷のフィットネスクラブ'
    end

    it "有効な投稿してその後投稿物を削除し成功のメッセージまで出る", js: true do
      submit_valid_micropost
      expect(current_path).to eq root_path
      expect(page).to have_selector '.alert-success'
      click_on '渋谷のフィットネスクラブ'
      visit current_path
      click_on '削除する'
      expect(page.driver.browser.switch_to.alert.text).to eq "投稿した記事を削除しますか？"
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_selector '.alert-success'
    end

    it "建物名を登録している有効な投稿を行った場合は記事内に地図が表示されている" do
      fill_in '(※必須)記事の題名', with: '渋谷のフィットネスクラブ', match: :first
      fill_in '(※必須)サービスの金額を入力してください', with: '月額500円', match: :first
      fill_in '(※任意)建物や住所がある場合は入力するとMAPとして出ます', with: '渋谷駅'
      find('trix-editor').click.set('良いサービス')
      attach_file 'micropost[picture]', "#{Rails.root}/db/images_seeds/1.png", match: :first
      click_button '投稿する'
      visit current_path
      click_on '渋谷のフィットネスクラブ'
      visit current_path
      expect(page.body).to have_content "【サービスを受けれる場所】"
    end

    it "有効な投稿して地図がないことを確認しその後投稿物を編集し編集成功のメッセージまで出る" do
      submit_valid_micropost
      expect(current_path).to eq root_path
      expect(page).to have_selector '.alert-success'
      visit current_path
      click_on '渋谷のフィットネスクラブ'
      expect(page.body).not_to have_content "【サービスを受けれる場所】"
      visit current_path
      click_on '記事の修正を行う'
      fill_in '記事の題名', with: '月額動画サービス', match: :first
      click_on '編集を反映する'
      expect(page).to have_selector '.alert-success'
    end

    it "ユーザーが削除された場合は記事も削除される" do
      submit_valid_micropost
      visit current_path
      expect { user.destroy }.to change(Micropost, :count).by(-1)
    end
  end

  context "無効な投稿一覧" do
    before do
      login_system(user)
      visit post_pages_path
    end

    it "記事の内容が2500文字を超える投稿は無効で尚且つエラーメッセージが出ている" do
      submit_invalid_micropost
      expect(current_path).to eq '/microposts'
      expect(page).to have_selector '.alert-danger'
    end

    it "値段項目のところで31文字を超える投稿は無効" do
      fill_in '(※必須)記事の題名', with: 'サービス題名', match: :first
      fill_in '(※必須)サービスの金額を入力してください', with: 'a' * 31, match: :first
      find('trix-editor').click.set('良いサービス')
      attach_file 'micropost[picture]', "#{Rails.root}/db/images_seeds/1.png", match: :first
      click_button '投稿する'
      expect(current_path).to eq '/microposts'
      expect(page).to have_selector '.alert-danger'
    end

    it "記事の題名を31文字を超える投稿は無効" do
      fill_in '(※必須)記事の題名', with: 'a' * 31, match: :first
      fill_in '(※必須)サービスの金額を入力してください', with: '月額500円', match: :first
      find('trix-editor').click.set('良いサービス')
      attach_file 'micropost[picture]', "#{Rails.root}/db/images_seeds/1.png", match: :first
      click_button '投稿する'
      expect(current_path).to eq '/microposts'
      expect(page).to have_selector '.alert-danger'
    end

    it "記事内で住所または建物名が31文字を超える投稿は無効" do
      fill_in '(※必須)記事の題名', with: 'サービスの題名', match: :first
      fill_in '(※必須)サービスの金額を入力してください', with: '月額500円', match: :first
      fill_in '(※任意)建物や住所がある場合は入力するとMAPとして出ます', with: 'a' * 31
      find('trix-editor').click.set('良いサービス')
      attach_file 'micropost[picture]', "#{Rails.root}/db/images_seeds/1.png", match: :first
      click_button '投稿する'
      expect(current_path).to eq '/microposts'
      expect(page).to have_selector '.alert-danger'
    end

    it "記事に画像が添付されていない投稿は無効" do
      fill_in '(※必須)記事の題名', with: 'フィットネスクラブ', match: :first
      fill_in '(※必須)サービスの金額を入力してください', with: '月額500円', match: :first
      find('trix-editor').click.set('良いサービス')
      click_button '投稿する'
      expect(current_path).to eq '/microposts'
      expect(page).to have_selector '.alert-danger'
    end
  end
end
