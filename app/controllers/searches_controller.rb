class SearchesController < ApplicationController
  before_action :logged_in_user

  def index
    @user = current_user
    if params[:search].length > 100
      @alert = "検索ワードは100文字以下にしてください"
      render 'searches/index'
    elsif params[:search].blank?
      @alert = "検索ワードをいれてください"
      render 'searches/index'
    else
      @microposts = Micropost.where("name LIKE ?", "%#{params[:search]}%").
        or(Micropost.where("content LIKE ?", "%#{params[:search]}%")).paginate(page: params[:page])
      @title = "'#{params[:search]}'の検索結果"
    end
  end

  def new
  end

  def show
    redirect_to new_search_path
  end
end