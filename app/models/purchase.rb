class Purchase < ActiveRecord::Base
  belongs_to :pack
  belongs_to :user

  def self.charge params, user

    purchase = Purchase.new
    
    begin      
      pack = Pack.find(params[:pack_id])
      amount = params[:price].to_i * 100

      unless pack.price == params[:price].to_f or pack.special_price == params[:price].to_f
        raise "El precio enviado es diferente al precio del paquete."
      end

      description = pack.description
      currency = "MXN"
      card = params[:token]

      charge = Conekta::Charge.create({
        amount: amount,
        currency: currency,
        description: description,
        card: card,
        details: {
          name: "#{user.first_name} #{user.last_name}",
          email: user.email,
          phone: user.phone,
          line_items: [{
            name: description,
            description: "Paquete nbici",
            unit_price: amount,
            quantity: 1
          }]
        }
      })

      purchase.update_attributes(
        user: user,
        pack: pack,
        uid: charge.id,
        object: charge.object, 
        livemode: charge.livemode, 
        status: charge.status,
        description: charge.description,
        amount: charge.amount,
        currency: charge.currency,
        payment_method: charge.payment_method,
        details: charge.details
      )

      user.update_attributes(classes_left: (user.classes_left.nil? ? 0 : user.classes_left)  + pack.classes, last_class_purchased: Time.zone.now)

    rescue Conekta::ParameterValidationError => e
      purchase.errors.add(:error_validating_parameters, e.message)
    rescue Conekta::ProcessingError => e
      purchase.errors.add(:error_charging_card, e.message)
    rescue Conekta::Error => e
      purchase.errors.add(:non_normal_operation_flow, e.message)
    end
    return purchase
    
  end
end
