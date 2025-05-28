class ApplicationController < ActionController::Base
  include SessionsHelper

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def current_ability
    @current_ability ||= Ability.new(current_admin || current_user)
  end

  def hello
    render html: 'hello, world!'
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Please log in.'

      redirect_to login_url
    end
  end
end
