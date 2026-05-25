# CSI2441 Assignment 2 - ThoughtVault
# Student: Vinith Magheswaran (ID: 10676287)
# CategoriesController - CRUD for philosophical categories; create/edit/delete admin-only

class CategoriesController < ApplicationController
  before_action :require_login
  before_action :set_category, only: %i[show edit update destroy]
  # Only administrators may create, edit, or remove categories
  before_action :admin_only, only: %i[index new create edit update destroy]

  # Admin only: list all categories
  def index
    @categories = Category.order(:name)
  end

  # All authenticated users can view a single category
  def show
  end

  # Admin only: form to add a new category
  def new
    @category = Category.new
  end

  # Admin only: form to edit an existing category
  def edit
  end

  # Admin only: save new category
  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to @category, notice: "Category created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Admin only: update an existing category
  def update
    if @category.update(category_params)
      redirect_to @category, notice: "Category updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Admin only: delete a category (cascades to remove quote_tags)
  def destroy
    @category.destroy!
    redirect_to categories_path, notice: "Category removed.", status: :see_other
  end

  private

  # Fetch category by ID
  def set_category
    @category = Category.find(params[:id])
  end

  # Permitted parameters for category form
  def category_params
    params.require(:category).permit(:name)
  end

  # Restrict actions to admin users only
  def admin_only
    unless admin_user?
      flash[:alert] = "Only administrators can manage categories."
      redirect_to dashboard_path
    end
  end
end
