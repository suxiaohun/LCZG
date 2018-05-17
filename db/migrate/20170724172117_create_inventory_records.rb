class CreateInventoryRecords < ActiveRecord::Migration
  def change
    create_table :inventory_records do |t|
      t.integer :good_id
      t.integer :count, :default => 0
      t.decimal :price, :precision => 10, :scale => 2, :default => 0.00
      t.date :inv_date, :default => Date.today
      t.string :flag, :default => 'IN'

      t.timestamps
    end
  end
end
