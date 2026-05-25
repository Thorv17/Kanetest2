class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_login, only: %i[show edit update destroy index]
  before_action :admin_only, only: %i[index]
  before_action :verify_ownership, only: %i[show edit update destroy]

  # Admin only: list all users
  def index
    @users = User.order(:lname, :fname)
  end

  def show
  end

  # Public sign-up
  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    @user.status = "Active" unless admin_user?
    @user.is_admin = false   unless admin_user?

    if @user.save
      redirect_to login_path, notice: "Account created! Please sign in."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    update_attrs = user_params
    # Don't update password if field was left blank
    if update_attrs[:password].blank?
      update_attrs = update_attrs.except(:password)
    end

    if @user.update(update_attrs)
      redirect_to(admin_user? ? users_path : dashboard_path,
                  notice: "Account details updated.")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy!
    redirect_to(admin_user? ? users_path : root_path,
                notice: "Account removed.", status: :see_other)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password, :is_admin, :status)
  end

  def admin_only
    unless admin_user?
      flash[:alert] = "That area is restricted to administrators."
      redirect_to dashboard_path
    end
  end
end
