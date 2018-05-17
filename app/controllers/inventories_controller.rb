class InventoriesController < ApplicationController
  before_action :set_current_menu

  before_action :set_inventory, only: [:show, :edit, :update, :destroy]


  def inv_records

    records_scope =  InventoryRecord.with_base_info.order('created_at desc')
    records_scope = records_scope.where("g.name like '%#{params[:name]}%'") if params[:name].present?
    records_scope = records_scope.where("g.code like '%#{params[:code]}%'") if params[:code].present?
    records_scope = records_scope.where(:inv_date=>params[:inv_date]) if params[:inv_date].present?
    records_scope = records_scope.where(:flag=>params[:flag]) if params[:flag].present?

    @records =records_scope.page params[:page]


  end


  def print_inventory
    @inventories = Inventory.with_base_info.order('updated_at desc')
  end

  # GET /inventories
  # GET /inventories.json
  def index
    @inventories = Inventory.with_base_info.order('updated_at desc').page params[:page]
  end

  # GET /inventories/1
  # GET /inventories/1.json
  def show
  end

  # GET /inventories/new
  def new
    @inventory = Inventory.new
  end

  # GET /inventories/1/edit
  def edit
  end

  # POST /inventories
  # POST /inventories.json
  def create
    @inventory = Inventory.where(:good_id => inventory_params[:good_id]).first

    if @inventory.present?
      # 商品入库 需要计算平均单价
      price = (@inventory.count*@inventory.price + inventory_params[:count].to_i*params[:price].to_d)/(@inventory.count+inventory_params[:count].to_i)

      @inventory.price = price
      @inventory.count+= inventory_params[:count].to_i
      @inventory.amount+= inventory_params[:count].to_i*params[:price].to_d
    else
      @inventory = Inventory.new(inventory_params)
      @inventory.price = params[:price]
      @inventory.amount+= @inventory.price*@inventory.count
    end

    good = Good.where(:id=>inventory_params[:good_id]).first

    # 每次入库需要记录明细日志
    InventoryRecord.create(:good_id => @inventory.good_id,
                           :count=>inventory_params[:count],
                           :price=>inventory_params[:price]
    )


    respond_to do |format|
      if @inventory.save
        format.html {redirect_to inventories_path, notice: 'Inventory was successfully created.'}
        format.json {render action: 'show', status: :created, location: @inventory}
      else
        format.html {render action: 'new'}
        format.json {render json: @inventory.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /inventories/1
  # PATCH/PUT /inventories/1.json
  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html {redirect_to inventories_path, notice: 'Inventory was successfully updated.'}
        format.json {head :no_content}
      else
        format.html {render action: 'edit'}
        format.json {render json: @inventory.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /inventories/1
  # DELETE /inventories/1.json
  def destroy
    @inventory.destroy
    respond_to do |format|
      format.html {redirect_to inventories_url}
      format.json {head :no_content}
    end
  end

  private
  def set_current_menu
    @_current_menu = 'inventory'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def inventory_params
    params.require(:inventory).permit(:good_id, :count)
  end
end
