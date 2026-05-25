class CategoriesController < ApplicationController
  before_action :require_login
  before_action :set_category, only: %i[show edit update destroy]

  # Only admin can list/manage all categories
  def index
    unless admin_user?
      flash[:alert] = "Only administrators can manage categories."
      redirect_to dashboard_path and return
    end
    @categories = Category.order(:name)
  end

  def show
  end

  def new
    @category = Category.new
  end

  def edit
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to @category, notice: "Category created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to @category, notice: "Category updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy!
    redirect_to categories_path, notice: "Category removed.", status: :see_other
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
