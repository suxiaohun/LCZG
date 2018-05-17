class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number, :limit => 50
      t.date :order_date
      t.integer :customer_id
      t.decimal :total_amount, :precision => 10, :scale => 2, :default => 0.00

      t.text :remark

      t.timestamps
    end
  end
end
