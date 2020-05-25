require 'rails_helper'

RSpec.describe "HomePages", type: :request do
  describe "GET /home" do
    it "homeへアクセス可能" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /help" do
    it "ヘルプにアクセス可能" do
      get help_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /about" do
    it "アバウトにアクセス可能" do
      get about_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    it "お問い合わせにアクセス可能" do
      get contact_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /policy" do
    it "利用規約へアクセス可能" do
      get policy_path
      expect(response).to have_http_status(:success)
    end
  end
end
