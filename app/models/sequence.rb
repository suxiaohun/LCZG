class Sequence < ApplicationRecord
  validates_uniqueness_of :object_name, :scope => :opu_id
  validates_presence_of :object_name, :seq_max, :seq_next



  # 自动调用前缀+补0
  def parse_val
    seq_next = self.seq_next.to_s.rjust(self.seq_length,'0')
    if self.rules.present? && self.rules.include?("###sequence###")
      seq_next = rules.gsub("###sequence###", seq_next)
    end
    seq_next
  end


  # 根据对象自身获得sequence
  def self.next_val_by_seq(seq)
    increment_counter(:seq_next, seq.id)
    seq.reload
    seq.parse_val
  end


  # 生成sequence_by_id
  def self.next_val_by_id(seq_id)
    return -1 unless seq_id
    seq = Sequence.where(:id => seq_id)
    return -1 unless seq.any?
    seq = seq.first
    increment_counter(:seq_next, seq.id)
    seq.reload
    seq.parse_val
  end

  # 生成sequence_by_object_name
  def self.next_val_by_object_name(obj_name)
    return -1 unless obj_name
    seq = Sequence.where(:object_name => obj_name)
    return -1 unless seq.any?
    seq = seq.first
    increment_counter(:seq_next, seq.id)
    seq.reload
    seq.parse_val
  end

  # 重置计数器/规则
  def self.reset(id, rules)
    return -1 unless id
    seq = Sequence.find(id)
    return -1 unless seq.present?
    seq.seq_next = 0
    seq.rules = (rules + '###sequence###') if rules.present?
    seq.save!
  end

end
