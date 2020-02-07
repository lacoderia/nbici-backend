class MenuPurchasesController < ApiController
  include ErrorSerializer

  before_action :authenticate_user!, only: [:charge]

  # POST /menu_purchases/charge
  def charge
    begin
      menu_purchase = MenuPurchase.charge(params, current_user)
      SendEmailJob.perform_later("menu_purchase", current_user, menu_purchase)
      render json: menu_purchase
    rescue Exception => e
      menu_purchase = MenuPurchase.new
      if e.try(:message_to_purchaser)
        error = e.message_to_purchaser
      else
        error = e.message
      end
      menu_purchase.errors.add(:error_creating_menu_purchase, error)
      render json: ErrorSerializer.serialize(menu_purchase.errors), status: 500
    end
  end 
  
end

