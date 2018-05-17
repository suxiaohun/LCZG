class CreateInventories < ActiveRecord::Migration
  def change
    create_table :inventories do |t|
      t.integer :good_id, :null => false
      t.integer :count, :default => 0, :null => false
      t.decimal :price, :default => 0.00, :precision => 10, :scale => 2
      t.decimal :amount, :default => 0.00, :precision => 10, :scale => 2

      t.text :remark

      t.timestamps
    end
  end
end
