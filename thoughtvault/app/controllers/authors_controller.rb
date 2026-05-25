# CSI2441 Assignment 2 - MyQuote
# Student: Vinith Magheswaran (ID: 10676287)
# AuthorsController - CRUD for philosophers/thinkers; accessible to all authenticated users

class AuthorsController < ApplicationController
  before_action :require_login
  before_action :set_author, only: %i[show edit update destroy]

  def index
    @authors = Author.order(:lname, :fname)
  end

  def show
  end

  def new
    @author = Author.new
  end

  def edit
  end

  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to @author, notice: "Thinker added to MyQuote."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @author.update(author_params)
      redirect_to @author, notice: "Thinker details updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @author.destroy!
    redirect_to authors_path, notice: "Thinker removed from MyQuote.", status: :see_other
  end

  private

  def set_author
    @author = Author.find(params[:id])
  end

  def author_params
    params.require(:author).permit(:fname, :lname, :birth_yr, :death_yr, :bio)
  end
end
