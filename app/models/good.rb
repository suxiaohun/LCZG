class Good < ApplicationRecord

  paginates_per 7

  scope :with_inventory,->{
    joins("inner join #{Inventory.table_name} inv on inv.good_id = #{table_name}.id")
  }

end
