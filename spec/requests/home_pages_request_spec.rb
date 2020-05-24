require 'rails_helper'

RSpec.describe "HomePages", type: :request do
  describe "GET /home" do
    it "homeへアクセス可能" do
      get "/home"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /help" do
    it "ヘルプにアクセス可能" do
      get "/help"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /about" do
    it "アバウトにアクセス可能" do
      get "/about"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /contact" do
    it "お問い合わせにアクセス可能" do
      get "/contact"
      expect(response).to have_http_status(:success)
    end
  end
end
