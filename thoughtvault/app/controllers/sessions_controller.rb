class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to(admin_user? ? admin_path : dashboard_path, notice: "You are already signed in.")
    end
  end

  def create
    email    = params[:email].to_s.strip
    password = params[:password].to_s

    if email.blank? || password.blank?
      flash.now[:alert] = "Email and password are both required."
      return render :new, status: :unprocessable_entity
    end

    account = User.find_by(email: email.downcase)

    if account.nil? || !account.authenticate(password)
      flash.now[:alert] = "Incorrect email or password. Please try again."
      render :new, status: :unprocessable_entity
    elsif account.status == "Suspended"
      flash.now[:alert] = "Your account has been suspended. Contact support for assistance."
      render :new, status: :unprocessable_entity
    elsif account.status == "Banned"
      flash.now[:alert] = "Your account has been banned. Contact support for assistance."
      render :new, status: :unprocessable_entity
    else
      session[:user_id]  = account.id
      session[:fname]    = account.fname
      session[:is_admin] = account.is_admin
      redirect_to(account.is_admin ? admin_path : dashboard_path,
                  notice: "Welcome back, #{account.fname}!")
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:fname)
    session.delete(:is_admin)
    redirect_to root_path, notice: "You have been signed out successfully."
  end
end
