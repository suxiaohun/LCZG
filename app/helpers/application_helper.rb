module ApplicationHelper


  def nav_menus
    menu_hash = Hash.new
    menu_hash[:order] = {:name=>'出货单',:path=>orders_path}
    menu_hash[:inventory] = {:name=>'库存',:path=>inventories_path}
    menu_hash[:customer] = {:name=>'客户',:path=>customers_path}
    menu_hash[:good] = {:name=>'商品',:path=>goods_path}

    menus = ''
    menu_hash.each do |k,v|
      if @_current_menu == k.to_s
        _tab = link_to(v[:name], v[:path],{:class => 'current_menu'})
      else
        _tab = link_to(v[:name], v[:path])
      end
      menus << content_tag(:li, _tab)
    end
    menus.html_safe
  end

  def link_modal(name, options={}, html_options={})
    link_to name, options, html_options.merge({:rel => 'modal'})
  end




end
