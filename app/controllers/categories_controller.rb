class CategoriesController < ApplicationController
  def category
  end

  def other
    @title = "その他"
    @categories = Micropost.where(category: @title)
    render 'categories/category'
  end

  def school
    @title = "スクール、塾関連"
    @categories = Micropost.where(category: @title)
    render 'categories/category'
  end

  def fitness
    @title = "フィットネスクラブ"
    @categories = Micropost.where(category: @title)
    render 'categories/category'
  end

  def beautysalon
    @title = "美容室、美容院"
    @categories = Micropost.where(category: @title)
    render 'categories/category'
  end

  def subscription
    @title = "サブスクリプション"
    @categories = Micropost.where(category: @title)
    render 'categories/category'
  end

  def music
    @title = "音楽、動画配信サービス"
    @categories = Micropost.where(category: @title)
    render 'categories/category'
  end

  def game
    @title = "アプリ、ゲーム配信サービス"
    @categories = Micropost.where(category: @title)
    render 'categories/category'
  end

  def fanclub
    @title = "ファンクラブ"
    @categories = Micropost.where(category: @title)
    render 'categories/category'
  end

  def salon
    @title = "オンラインサロン"
    @categories = Micropost.where(category: @title)
    render 'categories/category'
  end
end
