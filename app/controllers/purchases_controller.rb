class PurchasesController < ApiController
  include ErrorSerializer

  before_action :authenticate_user!, only: [:charge]

  def charge
    begin
      purchase = Purchase.charge(params, current_user)
      if purchase.errors.empty?
        render json: purchase
      else
        render json: ErrorSerializer.serialize(purchase.errors), status: 500
      end
    rescue Exception => e
      purchase = Purchase.new
      purchase.errors.add(:error_creating_purchase, e.message)
      render json: ErrorSerializer.serialize(purchase.errors), status: 500
    end

  end
  
end
