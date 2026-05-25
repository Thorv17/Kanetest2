class HomeController < ApplicationController
  before_action :require_login, only: %i[uindex aindex uquotes]

  # Public landing page — shows 10 most recent public quotes
  def index
    @recent_quotes = Quote.includes(:author)
                          .where(is_public: true)
                          .order(created_at: :desc)
                          .limit(10)
  end

  # Standard user dashboard
  def uindex
    redirect_to admin_path if admin_user?
  end

  # Admin dashboard
  def aindex
    unless admin_user?
      flash[:alert] = "Access restricted to administrators."
      redirect_to dashboard_path
    end
  end

  # Logged-in user's own quote collection
  def uquotes
    @my_quotes = Quote.includes(:author, :categories)
                      .where(user_id: current_user.id)
                      .order(created_at: :desc)
  end
end
