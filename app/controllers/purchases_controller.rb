class PurchasesController < ApiController
  include ErrorSerializer

  before_action :authenticate_user!, only: [:charge]

  # POST /purchases/charge
  def charge
    begin
      purchase = Purchase.charge(params, current_user)
      SendEmailJob.perform_later("purchase", current_user, purchase)
      render json: purchase
    rescue Exception => e
      purchase = Purchase.new
      purchase.errors.add(:error_creating_purchase, e.message)
      render json: ErrorSerializer.serialize(purchase.errors), status: 500
    end

  end
  
end
