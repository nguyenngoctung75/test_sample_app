module SessionsHelper
  def log_in(user)
    # Sau khi dang nhap thanh cong, luu id cua user vao session
    # Luc nay session chi chua id cua user khong chua gi khac
    session[:user_id] = user.id #sessions = { :user_id => user.id }
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
