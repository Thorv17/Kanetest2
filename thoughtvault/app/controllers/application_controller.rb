class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?, :admin_user?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def admin_user?
    session[:is_admin] == true
  end

  def page_not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end

  private

  def require_login
    unless logged_in?
      flash[:alert] = "Please sign in to access that page."
      redirect_to login_path
    end
  end

  def verify_ownership(resource = @user)
    return if admin_user?

    owner_id = resource.is_a?(User) ? resource.id : resource.user_id
    unless owner_id == current_user.id
      flash[:alert] = "You do not have permission to access that resource."
      redirect_to dashboard_path
    end
  end
end
