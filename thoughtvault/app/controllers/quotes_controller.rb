# CSI2441 Assignment 2 - ThoughtVault
# Student: Vinith Magheswaran (ID: 10676287)
# QuotesController - CRUD operations for quotes with role-based access control

class QuotesController < ApplicationController
  before_action :require_login
  before_action :set_quote, only: %i[show edit update destroy]
  before_action :check_visibility, only: %i[show]
  # Explicitly pass @quote so verify_ownership checks quote.user_id not @user (which is nil here)
  before_action -> { verify_ownership(@quote) }, only: %i[edit update destroy]

  # List quotes: admins see all public quotes; standard users see their own quotes
  def index
    if admin_user?
      @quotes = Quote.includes(:author, :user).where(is_public: true).order(created_at: :desc)
    else
      @quotes = Quote.includes(:author).where(user_id: current_user.id).order(created_at: :desc)
    end
  end

  # Display a single quote (visibility checked by before_action)
  def show
  end

  # Form for creating a new quote; admins cannot create quotes
  def new
    if admin_user?
      flash[:alert] = "Administrators do not collect quotes. Use a standard user account."
      redirect_to admin_path and return
    end
    @quote = Quote.new
    # Pre-build 4 category tag slots for the form UI
    4.times { @quote.quote_tags.build }
  end

  # Form for editing an existing quote; ensure form always shows 4 category slots
  def edit
    existing = @quote.quote_tags.size
    (4 - existing).times { @quote.quote_tags.build } if existing < 4
  end

  # Save new quote to database
  def create
    @quote = Quote.new(quote_params)

    if @quote.save
      redirect_to @quote, notice: "Your quote has been saved to ThoughtVault!"
    else
      # Rebuild form slots on validation failure
      pad_quote_tags
      render :new, status: :unprocessable_entity
    end
  end

  # Update an existing quote
  def update
    if @quote.update(quote_params)
      redirect_to @quote, notice: "Quote updated successfully."
    else
      pad_quote_tags
      render :edit, status: :unprocessable_entity
    end
  end

  # Delete a quote from the user's collection
  def destroy
    @quote.destroy!
    redirect_to my_quotes_path, notice: "Quote removed from your collection.", status: :see_other
  end

  private

  # Fetch quote by ID for show/edit/update/destroy actions
  def set_quote
    @quote = Quote.find(params[:id])
  end

  # Permitted parameters for quote creation/update, including nested quote_tags
  def quote_params
    params.require(:quote).permit(
      :content, :pub_year, :note, :is_public, :user_id, :author_id,
      quote_tags_attributes: %i[id category_id _destroy]
    )
  end

  # Authorization check: users can only view public quotes or their own private quotes
  def check_visibility
    unless @quote.is_public? || (logged_in? && @quote.user_id == current_user.id) || admin_user?
      flash[:alert] = "That quote is private."
      redirect_to root_path
    end
  end

  # Helper to ensure form displays exactly 4 category-tag input rows
  def pad_quote_tags
    existing = @quote.quote_tags.reject(&:marked_for_destruction?).size
    (4 - existing).times { @quote.quote_tags.build } if existing < 4
  end
end
