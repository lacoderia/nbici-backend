class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :update, :destroy]

  # GET /purchases
  # GET /purchases.json
  def index
    @purchases = Purchase.all

    render json: @purchases
  end

  # GET /purchases/1
  # GET /purchases/1.json
  def show
    render json: @purchase
  end

  # POST /purchases
  # POST /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)

    if @purchase.save
      render json: @purchase, status: :created, location: @purchase
    else
      render json: @purchase.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /purchases/1
  # PATCH/PUT /purchases/1.json
  def update
    @purchase = Purchase.find(params[:id])

    if @purchase.update(purchase_params)
      head :no_content
    else
      render json: @purchase.errors, status: :unprocessable_entity
    end
  end

  # DELETE /purchases/1
  # DELETE /purchases/1.json
  def destroy
    @purchase.destroy

    head :no_content
  end

  private

    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    def purchase_params
      params.require(:purchase).permit(:pack_id, :user_id, :uid, :object, :livemode, :status, :description, :amount, :currency, :payment_method, :details)
    end
end
