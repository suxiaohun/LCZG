class GoodsController < ApplicationController
  before_action :set_current_menu

  before_action :set_good, only: [:show, :edit, :update, :destroy]


  def get_good_by_id
    good = Good.find(params[:id])
    render :json => good
  end


  # GET /goods
  # GET /goods.json
  def index
    @goods = Good.all.order('code asc').page params[:page]
  end

  # GET /goods/1
  # GET /goods/1.json
  def show
  end

  # GET /goods/new
  def new
    @good = Good.new
  end

  # GET /goods/1/edit
  def edit
  end

  # POST /goods
  # POST /goods.json
  def create
    @good = Good.new(good_params)

    respond_to do |format|
      if @good.save
        format.html {redirect_to goods_path, notice: 'Good was successfully created.'}
        format.json {render action: 'show', status: :created, location: @good}
      else
        format.html {render action: 'new'}
        format.json {render json: @good.errors, status: :unprocessable_entity}
      end
    end
  end

  # PATCH/PUT /goods/1
  # PATCH/PUT /goods/1.json
  def update
    respond_to do |format|
      if @good.update(good_params)
        format.html {redirect_to goods_path, notice: 'Good was successfully updated.'}
        format.json {head :no_content}
      else
        format.html {render action: 'edit'}
        format.json {render json: @good.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /goods/1
  # DELETE /goods/1.json
  def destroy
    @good.destroy
    respond_to do |format|
      format.html {redirect_to goods_url}
      format.json {head :no_content}
    end
  end

  private


  def set_current_menu
    @_current_menu = 'good'
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_good
    @good = Good.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def good_params
    params.require(:good).permit(:code, :name, :price, :mode_desc, :mode_count, :kind, :remark)
  end
end
