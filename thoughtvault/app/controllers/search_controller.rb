class SearchController < ApplicationController
  # Allows visitors to search public quotes by category name or author name
  def index
    @query = params[:query].to_s.strip

    if @query.present?
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
