class ApplicationController < ActionController::Base
  
  def admin_user_logged_in
    unless current_admin_user
      redirect_to new_admin_user_session_path, notice: "Please login"
    end
  end
end
