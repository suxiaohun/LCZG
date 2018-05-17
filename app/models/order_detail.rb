class OrderDetail < ApplicationRecord

  scope :with_base_info ,->{
    joins("left join #{Good.table_name} g on g.id = #{table_name}.good_id").
        select("g.code good_code,g.name good_name,g.mode_count,g.mode_desc,#{table_name}.*")
  }
end
