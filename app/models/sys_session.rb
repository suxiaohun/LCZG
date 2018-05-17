class SysSession < ApplicationRecord
  self.table_name = :sessions


  # 清除过期session，以及hack攻击导致的一直活跃的session
  def self.sweep(time = 1.hour)
    if time.is_a?(String)
      time = time.split.inject { |count, unit| count.to_i.send(unit) }
    end

    where("updated_at < '#{time.ago.to_s(:db)}' OR created_at < '#{1.days.ago.to_s(:db)}'").delete_all
  end
end