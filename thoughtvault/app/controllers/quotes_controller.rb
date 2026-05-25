class QuotesController < ApplicationController
  before_action :require_login
  before_action :set_quote, only: %i[show edit update destroy]
  before_action :check_visibility, only: %i[show]
  before_action :verify_ownership, only: %i[edit update destroy]

  # Index: admins see all public quotes; standard users see their own quotes
  def index
    if admin_user?
      @quotes = Quote.includes(:author, :user).where(is_public: true).order(created_at: :desc)
    else
      @quotes = Quote.includes(:author).where(user_id: current_user.id).order(created_at: :desc)
    end
  end

  def show
  end

  def new
    if admin_user?
      flash[:alert] = "Administrators do not collect quotes. Use a standard user account."
      redirect_to admin_path and return
    end
    @quote = Quote.new
    # Pre-build 4 category tag slots for the form
    4.times { @quote.quote_tags.build }
  end

  def edit
    # Ensure there are always 4 tag slots visible during editing
    existing = @quote.quote_tags.size
    (4 - existing).times { @quote.quote_tags.build } if existing < 4
  end

  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      redirect_to @quote, notice: "Your quote has been saved to ThoughtVault!"
    else
      # Pad back to 4 slots on failure
      pad_quote_tags
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @quote.update(quote_params)
      redirect_to @quote, notice: "Quote updated successfully."
    else
      pad_quote_tags
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quote.destroy!
    redirect_to my_quotes_path, notice: "Quote removed from your collection.", status: :see_other
  end

  private

  def set_quote
    @quote = Quote.find(params[:id])
  end

  def quote_params
    params.require(:quote).permit(
      :content, :pub_year, :note, :is_public, :user_id, :author_id,
      quote_tags_attributes: %i[id category_id _destroy]
    )
  end

  # Prevents unauthenticated or unauthorised users from viewing private quotes
  def check_visibility
    unless @quote.is_public? || (logged_in? && @quote.user_id == current_user.id) || admin_user?
      flash[:alert] = "That quote is private."
      redirect_to root_path
    end
  end

  # Ensures the form always displays 4 category-tag rows
  def pad_quote_tags
    existing = @quote.quote_tags.reject(&:marked_for_destruction?).size
    (4 - existing).times { @quote.quote_tags.build } if existing < 4
  end
end
