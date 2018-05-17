class CustomFormBuilder < ActionView::Helpers::FormBuilder

  def date_field(object_name, options = {})
    field_id = options.delete(:id)|| object_name
    format = options.delete(:format) || 'yyyy-mm-dd'
    min_view = options.delete(:minView) || 2
    max_view = options.delete(:maxView) || 4  #数字代表值查看http://www.bootcss.com/p/bootstrap-datetimepicker/index.htm

    text_field(object_name, options.merge(:id => field_id, :size => 10, :readonly => 'readonly', :onclick => "initDateFields(this,'#{format}','#{min_view}','#{max_view}')", :class => " date-input #{options[:class]}",  :normal => true, :autocomplete => 'off'))
  end


end