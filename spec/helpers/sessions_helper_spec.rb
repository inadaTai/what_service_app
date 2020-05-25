require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let!(:user) { create(:user) }

  describe "#current_userについてのテスト" do
    it "永続的なセッションでユーザーが特定できているかテスト" do
      remember(user)
      expect(current_user).to eq user
      expect(current_user).to be_truthy
    end

    it "不適切なトークンをダイジェストに代入した時にcurrent_userがnilとなる" do
      remember(user)
      user.update_attribute(:remember_digest, User.digest(User.new_token))
      expect(current_user).to be_nil
    end
  end
end
