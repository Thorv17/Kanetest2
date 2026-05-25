# CSI2441 Assignment 2 - ThoughtVault
# Student: Vinith Magheswaran (ID: 10676287)
# SessionsController - Handles user authentication (login/logout)

class SessionsController < ApplicationController
  # Display login form; redirect if already logged in
  def new
    if logged_in?
      redirect_to(admin_user? ? admin_path : dashboard_path, notice: "You are already signed in.")
    end
  end

  # Authenticate user with email and password; create session if credentials valid
  def create
    email    = params[:email].to_s.strip
    password = params[:password].to_s

    # Validate that both email and password are provided
    if email.blank? || password.blank?
      flash.now[:alert] = "Email and password are both required."
      return render :new, status: :unprocessable_entity
    end

    # Find user by email (case-insensitive)
    account = User.find_by(email: email.downcase)

    # Check if user exists and password is correct
    if account.nil? || !account.authenticate(password)
      flash.now[:alert] = "Incorrect email or password. Please try again."
      render :new, status: :unprocessable_entity
    # Check if account is suspended (user exists but access is limited)
    elsif account.status == "Suspended"
      flash.now[:alert] = "Your account has been suspended. Contact support for assistance."
      render :new, status: :unprocessable_entity
    # Check if account is banned (user exists but access is completely denied)
    elsif account.status == "Banned"
      flash.now[:alert] = "Your account has been banned. Contact support for assistance."
      render :new, status: :unprocessable_entity
    # Credentials valid and account is Active; create session and redirect
    else
      session[:user_id]  = account.id
      session[:fname]    = account.fname
      session[:is_admin] = account.is_admin
      redirect_to(account.is_admin ? admin_path : dashboard_path,
                  notice: "Welcome back, #{account.fname}!")
    end
  end

  # Destroy session and sign out user
  def destroy
    session.delete(:user_id)
    session.delete(:fname)
    session.delete(:is_admin)
    redirect_to root_path, notice: "You have been signed out successfully."
  end
end
