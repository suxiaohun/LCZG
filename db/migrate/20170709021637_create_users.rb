class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login_name, :null => false, :limit => 50 # 登录名,不可为空
      t.string :name, :limit => 100
      t.string :email, :limit => 100
      t.string :phone, :limit => 100
      t.string :encrypted_password, :limit => 255, :null => false # 加密后的密码,由于安全原因，系统不会存储明文密码
      t.string :locked_flag, :limit => 1, :default => 'N' # 锁定标志位(Y/N),默认N
      t.integer :locked_time, :default => 600 # 锁定时间(单位：秒),默认10分钟，即600s
      t.datetime :locked_until_at # 锁定结束时间
      t.datetime :last_login_at # 最后一次登录时间
      t.string :status, :default => 'ENABLED' #启用/失效
      t.timestamps
    end
  end
end
