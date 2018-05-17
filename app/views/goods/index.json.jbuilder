json.array!(@goods) do |good|
  json.extract! good, :id, :code, :name, :price, :mode, :remark
  json.url good_url(good, format: :json)
end
