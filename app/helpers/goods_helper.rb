module GoodsHelper


  # 商品下拉选

  def goods_list
    Good.all.order("name asc").pluck(:name, :id)
  end

end
