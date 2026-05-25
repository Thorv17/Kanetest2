# CSI2441 Assignment 2 - MyQuote
# Student: Vinith Magheswaran (ID: 10676287)
# SearchController - Public search for quotes by category name or author name (no authentication required)

class SearchController < ApplicationController
  # Public search endpoint accessible to all visitors (authenticated or not)
  def index
    @query = params[:query].to_s.strip

    if @query.present?
      # Search public quotes by category name, author first name, or author last name
      @results = Quote.joins(:quote_tags, :categories)
                      .joins(:author)
                      .where(is_public: true)
                      .where(
                        "categories.name LIKE :q OR authors.fname LIKE :q OR authors.lname LIKE :q",
                        q: "%#{@query}%"
                      )
                      .distinct
                      .includes(:author, :categories)
    end
  end
end
