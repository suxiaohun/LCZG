module CustomersHelper


  #客户下拉选
  def customers_list
    Customer.all.pluck(:name,:id)
  end
end
