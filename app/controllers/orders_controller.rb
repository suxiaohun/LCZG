class OrdersController < ApplicationController
  before_action :set_current_menu

  before_action :set_order, only: [:show, :edit, :update, :destroy]

  def test

  end


  def get_goods
    not_ids = params[:not_ids].split(',')
    data_h = []
    goods = Good.with_inventory.where.not(:id => not_ids).order("name asc").each do |g|
      data = {}
      data[:label] = g[:name]
      data[:value] = g[:id]
      data[:unit_price] = g[:price]
      data[:unit_count] = g[:mode_count]
      data_h<<data
    end
    render :json => data_h
  end

  def print_pre

    render :layout => false

  end


  # GET /orders
  # GET /orders.json
  def index
    orders_scope = Order.with_base_info.order('created_at desc')
    orders_scope = orders_scope.where("c.name like '%#{params[:name]}%'") if params[:name].present?
    orders_scope = orders_scope.where(:order_date => params[:order_date]) if params[:order_date].present?
    @orders = orders_scope.page params[:page]
  end

  # GET /orders/1
  # GET /orders/1.json
  def show

    @details = OrderDetail.with_base_info.where(:order_id => params[:id])

  end

  # GET /orders/new
  def new
    @order = Order.new
    @infos = []
    @options = ''
    @goods = Good.with_inventory.order("name asc")
    @options = @goods.pluck(:name, :id)


  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(order_params)
    @order.number = SeqUtil.sequence_date_serial_reset('001n00012i8IyyjJakd6Om', 'ORDER', 'ORDER', '', 5)

    # 保存出货单主体信息
    @order.save

    # 保存出货单商品信息
    total_amount = 0
    good_id = params[:good]
    good_id.each_with_index do |gid, i|
      detail = OrderDetail.new
      detail.order_id = @order.id
      detail.good_id = gid
      detail.unit_price = params[:unit_price][i]
      detail.price = params[:price][i]
      detail.count = params[:count][i]
      detail.amount = params[:amount][i]
      detail.remark = params[:remark][i]
      detail.save

      # 要减去对应的库存
      inv = Inventory.where(:good_id => gid).first
      if inv
        inv.count -= detail.count
        inv.save
      end

      total_amount+= detail.amount


      # 每次出库需要记录明细日志
      InventoryRecord.create(:good_id => gid,
                             :count => params[:count][i],
                             :price => params[:price][i],
                             :flag => 'OUT'
      )

    end


    respond_to do |format|
      if @order.update_attribute(:total_amount, total_amount)
        format.html {redirect_to @order, notice: 'Order was successfully created.'}
        format.json {render action: 'show', status: :created, location: @order}
      else
        format.html {render action: 'new'}
        format.json {render json: @order.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html {redirect_to @order, notice: 'Order was successfully updated.'}
        format.json {head :no_content}
      else
        format.html {render action: 'edit'}
        format.json {render json: @order.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html {redirect_to orders_url}
      format.json {head :no_content}
    end
  end

  private
  def set_current_menu
    @_current_menu = 'order'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.with_base_info.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def order_params
    params.require(:order).permit(:number, :order_date, :customer_id, :customer_name)
  end
end
