# CSI2441 Assignment 2 - MyQuote
# Student: Vinith Magheswaran (ID: 10676287)
# HomeController - Landing pages, user dashboard, admin dashboard, and quote collection

class HomeController < ApplicationController
  # Public homepage does not require authentication; dashboards do
  before_action :require_login, only: %i[uindex aindex uquotes]

  # Public landing page — shows 10 most recent public quotes (visible to all visitors)
  def index
    @recent_quotes = Quote.includes(:author)
                          .where(is_public: true)
                          .order(created_at: :desc)
                          .limit(10)
  end

  # Standard user dashboard — redirects admin users to their own dashboard
  def uindex
    redirect_to admin_path if admin_user?
  end

  # Admin dashboard — restricted to admin users only
  def aindex
    unless admin_user?
      flash[:alert] = "Access restricted to administrators."
      redirect_to dashboard_path
    end
  end

  # Logged-in user's own complete quote collection (public and private quotes)
  def uquotes
    @my_quotes = Quote.includes(:author, :categories)
                      .where(user_id: current_user.id)
                      .order(created_at: :desc)
  end
end
