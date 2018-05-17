class SeqUtil

  def self.date_serial_new_obj(opu_id, model_name, type, prefix='', length=4, str='yyyymmdd')
    length = length.to_i
    prefix = prefix.to_s
    time_str = ''
    if str == 'yyyymmdd'
      time_str = Time.now.strftime('%Y%m%d').to_s
    elsif str == 'yyyy'
      time_str = Time.now.strftime('%Y').to_s
    elsif str == 'yyyymm'
      time_str = Time.now.strftime('%Y%m').to_s
    end
    # 如果没有规则，需要预先定义个规则，如果有，则更新日期并且sequence递增
    seq = Sequence.where(:object_name => "#{model_name}_#{type}", :opu_id => opu_id).first
    if seq.blank?
      seq = Sequence.new
      seq.rules = prefix + time_str + '###sequence###'
      seq.opu_id = opu_id #用来数据隔离
      seq.object_name = "#{model_name}_#{type}"
      seq.seq_length = length
      seq.seq_min = 1
      seq.seq_max = ('9'*length).to_i
      seq.save
    end

    # 根据日期判断是否需要重置规则
    rules = prefix + time_str

    #2016-08-17-除日期外，如果前缀改变，对应的sequence规则也要改变
    Sequence.reset(seq.id, rules) unless ((rules + '###sequence###') == seq.rules)
    
    seq
  end

=begin
  opu_id=>根据层级的不同可以存储不同的id，可以为公司id，也可以为项目id
  model_name=>model_name :Cmi::MaintenanceOrder
  type=>后缀， WB=>维保单；XJ=>巡检单；等等，推荐大写英文字母（后期界面展示可能会用到区分）
  prefix=>前缀，根据规则不同自行定义,不传值默认为空
  length=>流水号长度，根据需要自行填写，不传值默认是4位
  lag=>标志位，代表是否每日重置计数器，不传值默认是每天重置
=end

  #通用的“前缀”+“日期（20160406）（每天重置）”+“流水号（自定义位数）（每天重新计算）”
  #20160519--追加日期拆分格式，默认是yyyymmdd，可以单独使用yyyy/yyyymm
  def self.sequence_date_serial_reset(opu_id, model_name, type, prefix='', length=4, str='yyyymmdd')
    length = length.to_i
    prefix = prefix.to_s
    time_str = ''
    if str == 'yyyymmdd'
      time_str = Time.now.strftime('%Y%m%d').to_s
    elsif str == 'yyyy'
      time_str = Time.now.strftime('%Y').to_s
    elsif str == 'yyyymm'
      time_str = Time.now.strftime('%Y%m').to_s
    end
    #如果没有规则，需要预先定义个规则，如果有，则更新日期并且sequence递增
    seq = Sequence.where(:object_name => "#{model_name}_#{type}", :opu_id => opu_id).first
    if seq.blank?
      seq = Sequence.new
      seq.rules = prefix + time_str + '###sequence###'
      seq.opu_id = opu_id #用来数据隔离
      seq.object_name = "#{model_name}_#{type}"
      seq.seq_length = length
      seq.seq_min = 1
      seq.seq_max = ('9'*length).to_i
      seq.save
    end

    #根据日期判断是否需要重置规则
    rules = prefix + time_str

    # n = seq.rules.length
    #获取原规则日期
    # time_seq = seq.rules[n-14-time_str.length, time_str.length]
    # Sequence.reset(seq.id, rules) unless (time_str == time_seq)

    #2016-08-17-除日期外，如果前缀改变，对应的sequence规则也要改变
    Sequence.reset(seq.id, rules) unless ((rules + '###sequence###') == seq.rules)
    Sequence.next_val_by_seq(seq)
  end


  def self.sequence_common(opu_id, model_name, type, prefix='', length=10)
    opu_id = '001n00012i8IyyjJakd6Om' if opu_id.blank? #给opu_id加上默认值
    length = length.to_i
    prefix = prefix.to_s
    #如果没有规则，需要预先定义个规则，如果有，则更新日期并且sequence递增
    seq = Sequence.where(:object_name => "#{model_name}_#{type}", :opu_id => opu_id).first
    if seq.blank?
      seq = Sequence.new
      seq.rules = prefix + '###sequence###'
      seq.opu_id = opu_id #用来数据隔离
      seq.object_name = "#{model_name}_#{type}"
      seq.seq_length = length
      seq.seq_min = 1
      seq.seq_max = ('9'*length).to_i
      seq.save
    end
    Sequence.next_val_by_seq(seq)
  end

  def self.sequence_new_obj(opu_id, model_name, type, prefix='', length=10)
    opu_id = '001n00012i8IyyjJakd6Om' if opu_id.blank? #给opu_id加上默认值
    length = length.to_i
    prefix = prefix.to_s

    #如果没有规则，需要预先定义个规则
    seq = Sequence.where(:object_name => "#{model_name}_#{type}", :opu_id => opu_id).first
    if seq.blank?
      seq = Sequence.new
      seq.rules = prefix + '###sequence###'
      seq.opu_id = opu_id #用来数据隔离
      seq.object_name = "#{model_name}_#{type}"
      seq.seq_length = length
      seq.seq_min = 1
      seq.seq_max = ('9'*length).to_i
      seq.save
    end

    seq
  end


  #2016-05-16-批量生成序列号，给批量导入用
  def self.generate_numbers(id, size)
    begin
      size = size.to_i
      seq = Sequence.find(id)
      arr = []
      min = seq.seq_next + 1
      max = min + size - 1
      (min..max).each do |i|
        number = i.to_s
        number_length = i.to_s.length
        #不满长度补0
        while seq.seq_length > number_length do
          number = '0' + number
          number_length = number.length
        end

        if seq.rules.present? && seq.rules.include?("###sequence###")
          arr.push(seq.rules.gsub("###sequence###", number))
        end
      end
      seq.update_attributes!(:seq_next => max) unless arr.blank?
    rescue => e
      puts e.message.to_s
      arr = []
    end
    arr.reverse #将数组反转一下便于.pop调用及以后的排序
  end

end