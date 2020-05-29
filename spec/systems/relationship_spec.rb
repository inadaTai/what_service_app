require 'rails_helper'

RSpec.describe "フォローに関するテスト", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:other_user) }

  def valid_follow
    visit '/users/1'
    click_on 'フォロー'
    visit current_path
  end

  def valid_unfollow
    visit '/users/1'
    click_on 'フォロー解除'
    visit current_path
  end

  describe "ユーザーが他ユーザに対するフォロー確認テスト" do
    before do
      login_system(user)
    end

    it "ユーザーが他ユーザーをフォローできる" do
      login_system(other_user)
      valid_follow
      expect(page).to have_button 'フォロー解除'
    end

    it "フォローしたらfollowingカウントが増える" do
      login_system(other_user)
      expect { valid_follow }.to change(other_user.following, :count).by(1)
    end

    it "フォロー解除したらfollowersカウントが減る" do
      login_system(other_user)
      valid_follow
      expect { valid_unfollow }.to change(user.followers, :count).by(-1)
    end

    it "ユーザーが他ユーザーをフォロー解除ができる", js: true do
      login_system(other_user)
      valid_follow
      click_on 'フォロー解除'
      expect(page).to have_button 'フォロー'
    end

    it "自分のページにはフォローボタンは無い" do
      visit '/users/1'
      expect(page).not_to have_button 'フォロー'
    end
  end
end
