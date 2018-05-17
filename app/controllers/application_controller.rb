class ApplicationController < ActionController::Base

  # protect_from_forgery with: :exception

  before_action :check_if_require_login



# 检查是否需要登录
  def check_if_require_login
    # 如果session中存在user_id,则无需登录,否则转向登录页面
    if session[:user_id]
      # 如果会话存在，则设置current_user（防止User.current失效）
      User.current = User.find(session[:user_id])
      true
    else
      require_login
    end
  end

  # 跳转到登陆页面
  def require_login
    redirect_to({:controller => 'login', :action => 'login'})
  end

end
