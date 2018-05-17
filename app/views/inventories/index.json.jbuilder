json.array!(@inventories) do |inventory|
  json.extract! inventory, :id, :good_id, :amount
  json.url inventory_url(inventory, format: :json)
end
