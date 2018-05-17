class CreateGoods < ActiveRecord::Migration
  def change
    create_table :goods do |t|
      t.string :code
      t.string :name
      t.decimal :price, :precision => 10, :scale => 2, :default => 0.00
      t.integer :mode_count, :default => 1
      t.string :mode_desc, :default => '盒/件'
      t.string :kind, :limit => 1, :default => '1' # 商品类型，1成品，0半成品
      t.string :remark

      t.timestamps
    end
  end
end
