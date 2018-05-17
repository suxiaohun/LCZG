class Inventory < ApplicationRecord

  paginates_per 7


  validates_uniqueness_of :good_id, on: :create

  scope :with_base_info, -> {
    joins("inner join #{Good.table_name} g on g.id = #{table_name}.good_id").
        select("g.name good_name,g.code good_code,#{table_name}.*")
  }
end
