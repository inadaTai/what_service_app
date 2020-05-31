require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user) }

  describe "GET /notifications" do
    it "通知ページにアクセス可能" do
      log_in_as(user)
      get "/notifications"
      expect(response).to have_http_status(:success)
    end
  end
end
