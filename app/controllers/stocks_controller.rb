require 'pry-byebug'
require 'json'

class StocksController < ApplicationController
  before_action :is_stock?
  before_action :set_stock, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:edit, :update, :destroy]
  # GET /stocks
  # GET /stocks.json
  def index
    @stocks = Stock.all
  end

  # GET /stocks/1
  # GET /stocks/1.json
  def show
  		@rss = RssJob.getrss(@stock.ticker)
      #binding.pry
      @stocks_presenter = StockPresenter.new(@stock.ticker, current_user)
      @stock_data = @stocks_presenter.graph_data.to_json.html_safe
      @triggers = @stocks_presenter.triggers
      @ticker = @stock.ticker
  end

  # GET /stocks/new
  def new
    @stock = Stock.new
  end

  # GET /stocks/1/edit
  def edit
  end

  # POST /stocks
  # POST /stocks.json
  def create
    @stock = stock.new(stock_params)
    respond_to do |format|
      if @stock.save
        format.html { redirect_to @stock, notice: 'stock was successfully created.' }
        format.json { render :show, status: :created, location: @stock }
      else
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
    
    
  end

  # PATCH/PUT /stocks/1
  # PATCH/PUT /stocks/1.json
  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to @stock, notice: 'stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to stocks_url, notice: 'stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stock
      @stock = Stock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stock_params
      params.require(:stock).permit(:title, :description)
    end

    def is_stock?
      unless Stock.exists?(id: params[:id])
        redirect_to user_path(current_user), notice: 'Stock does not exists.'
      end
    end
end
