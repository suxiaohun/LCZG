class CreateOrderDetails < ActiveRecord::Migration
  def change
    create_table :order_details do |t|
      t.integer :order_id
      t.integer :good_id
      t.decimal :unit_price, :precision => 10, :scale => 2
      t.decimal :price, :precision => 10, :scale => 2
      t.integer :count, :default => 0
      t.decimal :amount, :precision => 10, :scale => 2
      t.text :remark

      t.timestamps
    end
  end
end
