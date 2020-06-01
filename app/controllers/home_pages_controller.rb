class HomePagesController < ApplicationController
  before_action :logged_in_user, only: [:post_pages, :timeline]
  MAX_RELOAD_POST = 15
  MAX_POST = 5

  def home
    if logged_in?
      @feed_items = current_user.feed.order(created_at: :desc).paginate(page: params[:page]).limit(MAX_RELOAD_POST).search(params[:search])
    else
      @feed_items = Micropost.all.order(created_at: :desc).limit(MAX_POST)
    end
  end

  def timeline
    if logged_in?
      @user = current_user
      @feed_items = current_user.follower_feed.where.not(user_id: current_user.id).order(created_at: :desc).
        paginate(page: params[:page])
    end
  end

  def post_pages
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end

  def about
  end

  def contact
  end
end
