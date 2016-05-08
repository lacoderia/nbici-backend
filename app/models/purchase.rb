class Purchase < ActiveRecord::Base
  belongs_to :pack
  belongs_to :user

  scope :with_users_and_appointments, -> {joins(:user)}

  def self.charge params, user
    
    pack = Pack.find(params[:pack_id])
    amount = params[:price].to_i * 100
    card = Card.find_by_uid(params[:uid])

    unless card
      raise "Tarjeta no encontrada o registrada."
    end

    unless pack.price == params[:price].to_f or pack.special_price == params[:price].to_f
      raise "El precio enviado es diferente al precio del paquete."
    end

    description = pack.description
    currency = "MXN"

    charge = Conekta::Charge.create({
      amount: amount,
      currency: currency,
      description: description,
      card: card.uid,
      details: {
        name: card.name,
        email: user.email,
        phone: card.phone,
        line_items: [{
          name: description,
          description: "Paquete nbici",
          unit_price: amount,
          quantity: 1
        }]
      }
    })

    purchase = Purchase.create!(
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

    return purchase
    
  end
end
