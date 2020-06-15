require 'rails_helper'

RSpec.describe "Categories", type: :request do
  describe "GET /fitness" do
    it "フィットネスクラブへアクセス可能" do
      get fitness_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /school" do
    it "スクール、塾にアクセス可能" do
      get school_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /subscription" do
    it "サブスクリプションにアクセス可能" do
      get subscription_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /music" do
    it "音楽、動画配信サービスにアクセス可能" do
      get music_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /game" do
    it "アプリ、ゲーム配信サービスへアクセス可能" do
      get game_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /salon" do
    it "オンラインサロンへアクセス可能" do
      get salon_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /beautysalon" do
    it "美容室、美容院へアクセス可能" do
      get beautysalon_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /fanclub" do
    it "ファンクラブへアクセス可能" do
      get fanclub_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /other" do
    it "その他へアクセス可能" do
      get other_path
      expect(response).to have_http_status(:success)
    end
  end
end
