class PurchaseSerializer < ActiveModel::Serializer

  attributes :id, :user_id, :pack_id, :uid, :object, :livemode, :status, :description, :amount, :currency, :payment_method, :details

end
