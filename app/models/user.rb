class User < ApplicationRecord

  paginates_per 7

  self.table_name = :users


  # 开始进行登录尝试
  def self.try_login(username, password)
    user = unscoped.where(:login_name => username).first
    begin
      return false, '用户名密码错误' if user.blank?
      return false, '用户不可用，请联系管理员！' unless user.status=='ENABLED'
      return false, '用户已被锁定，请15分钟后再试！或联系管理员' if user.locked?
      return false, '用户名密码错误' unless encrypt_password(password) == user.encrypted_password

      user.update_attributes!(:last_login_at => Time.now)
      return user, 'success'
    rescue Exception => e
      return false, e.message.to_s
    end


  end


  # 取得系统当前登陆用户
  def self.current
    @current_user
  end

  # 设置系统当前登陆用户
  def self.current=(current_user)
    @current_user = current_user
  end


  # 验证用户是否锁定
  def locked?
    self.locked_flag == 'Y'
  end

  private



  # 加密密码
  def self.encrypt_password(password)
    Digest::SHA1.hexdigest(password || '')
  end
end
