class SessionsController < ApplicationController
  def new
    if session[:user_name]
      @notice = "#{session[:user_name]}でログインしています。"
    end
  end

  def create
 
    if params.key?(:name) || params.key?(:password)
      user = User.find_by_account_name(params[:name])
      if user && user.authenticate(params[:password])
        session[:user_name] = params[:name]
        session[:admin_flag] = false
        redirect_to "/top_page"
      else
        session[:user_name] = nil
        session[:admin_flag] = nil
        flash[:error] = "ユーザ名かパスワードが違います．"
        redirect_to root_url
      end
    end
  end

    def admin_new
    if session[:user_name]
      @notice = "#{session[:user_name]}でログインしています。"
    end
  end

  def admin_create
 
    if params.key?(:name) || params.key?(:password)
      user = User.find_by_account_name(params[:name])
      if user && user.authenticate(params[:password]) && User.where(account_name: params[:name]).first.admin_flag == true
        session[:user_name] = params[:name]
        session[:admin_flag] = User.where(account_name: params[:name]).first.admin_flag
        redirect_to "/top_page"
      else
        session[:user_name] = nil
        session[:admin_flag] = nil
        flash[:error] = "ユーザ名かパスワードが違います．"
        redirect_to admin_login_path
      end
    end
  end

  def destroy
    reset_session
    @current_user = nil   # 安全のため
    redirect_to root_url, status: :see_other
  end

  def index
  end
end
