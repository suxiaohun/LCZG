class InventoryRecord < ApplicationRecord

  paginates_per 7

  scope :with_base_info,->{
    joins("left join #{Good.table_name} g on g.id = #{table_name}.good_id").
        select("g.name good_name,g.code good_code,#{table_name}.*")
  }
end
