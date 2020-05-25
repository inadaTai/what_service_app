require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /signup" do
    it "新規登録ページへアクセス可能" do
      get signup_path
      expect(response).to have_http_status(:success)
    end
  end
end
