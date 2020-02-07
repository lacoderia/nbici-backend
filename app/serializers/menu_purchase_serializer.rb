class MenuPurchaseSerializer < ActiveModel::Serializer

  attributes :id, :user, :appointment_id, :uid, :object, :livemode, :conekta_status, :description, :amount, :currency, :payment_method, :details, :notes, :status

  def user
    object.user
  end

end
