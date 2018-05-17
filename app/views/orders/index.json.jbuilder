json.array!(@orders) do |order|
  json.extract! order, :id, :number, :order_date, :customer_id, :customer_name
  json.url order_url(order, format: :json)
end
