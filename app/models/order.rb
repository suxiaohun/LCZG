class Order < ApplicationRecord

  paginates_per 5

  scope :with_base_info,->{
    joins("left join #{Customer.table_name} c on c.id = #{table_name}.customer_id ").
        select("c.name customer_name,#{table_name}.* ")
  }

end
