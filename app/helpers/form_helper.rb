module FormHelper

  def date_field_tag(field, options = {})
    field_id = options.delete(:id)|| field
    format = options.delete(:format) || "yyyy-mm-dd"
    min_view = options.delete(:minView) || 2
    max_view = options.delete(:maxView) || 4  #数字代表值查看http://www.bootcss.com/p/bootstrap-datetimepicker/index.htm


    text_field_tag(field_id, options[:value], :size => 20, :class => "date-input", :id => field_id, :onclick => "initDateFields(this,'#{format}','#{min_view}','#{max_view}')", :autocomplete => "off", :normal => true)

  end


end
