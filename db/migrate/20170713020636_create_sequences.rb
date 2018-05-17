class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.string :opu_id, :limit => 32 # 默认 “001n00012i8IyyjJakd6Om”,判断是哪个公司或集团
      t.string :object_name, :limit => 50 # 用来判定sequence的独特性，一般用model + code ，不允许重复
      t.integer :seq_next, :default => 0
      t.integer :seq_length, :null => false, :default => 4 # 编码长度
      t.integer :seq_min, :null => false, :default => 1 # 最小值
      t.integer :seq_max, :null => false, :default => 9999 # 最大值
      t.string :rules, :limit => 150 # 编码规则, AAA###sequence###,AAA是随意填写，其他是默认写法
      t.string :status_code, :default => 'ENABLED', :null => false
      t.timestamps
    end
  end
end
