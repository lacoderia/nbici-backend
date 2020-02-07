class MenuPurchase < ActiveRecord::Base
  belongs_to :user
  belongs_to :appointment
  has_many :purchased_items
  has_many :menu_items, :through => :purchased_items

  STATUSES = [
    'SOLD',
    'CANCELLED',
    'REFUNDED'
  ]
  
  validates :status, inclusion: {in: STATUSES}
  
  state_machine :status, :initial => 'SOLD' do
    transition 'SOLD' => 'CANCELLED', on: :cancel
    transition ['SOLD', 'CANCELLED'] => 'REFUNDED', on: :refund
  end

  def self.calculate_amount menu_items

    amount = 0
    menu_items.each do |menu_item|
      amount += menu_item[:menu_item].price * menu_item[:amount]
    end

    return amount
    
  end

  def add_items menu_items

    menu_items.each do |menu_item|
      PurchasedItem.create!(menu_purchase: self, menu_item: menu_item[:menu_item], amount: menu_item[:amount])
    end

  end

  def self.charge params, user
    
    card = Card.find_by_uid(params[:uid]) 

    if not card
      raise "Tarjeta no encontrada o registrada."
    end

    appointment = Appointment.find(params[:appointment_id])

    conekta_amount = params[:price].to_i * 100

    menu_items = []
    params[:menu_items].each do |menu_item|
      menu_items << {menu_item: MenuItem.find(menu_item[:id]), amount: menu_item[:amount].to_i}
    end
    
    calculated_amount = self.calculate_amount(menu_items)

    if params[:price].to_f != calculated_amount
      raise "El precio enviado es diferente al precio del producto."
    end
 
    description = "Menu Dafit"
    currency = "MXN"
    credits = user.credits

    if not user.test?

      charge = Conekta::Charge.create({
          amount: conekta_amount,
          currency: currency,
          description: description,
          card: card.uid,
          details: {
            name: card.name,
            email: user.email,
            phone: card.phone,
            line_items: [{
              name: description,
              description: "Compra Nbici menu Dafit",
              unit_price: conekta_amount,
              quantity: 1
            }]
          }
        })

      menu_purchase = MenuPurchase.create!(
        user: user,
        appointment: appointment,
        uid: charge.id,
        object: charge.object, 
        livemode: charge.livemode, 
        conekta_status: charge.status,
        description: charge.description,
        amount: charge.amount,
        currency: charge.currency,
        payment_method: charge.payment_method,
        details: charge.details,
        notes: params[:notes],
        status: 'SOLD'
      )

    else

      menu_purchase = MenuPurchase.create!(
        user: user,
        appointment: appointment,
        uid: nil,
        object: nil, 
        livemode: nil, 
        conekta_status: nil,
        description: description,
        amount: amount,
        currency: currency,
        payment_method: nil,
        details: nil,
        notes: params[:notes],
        status: 'SOLD'
      )

    end

    menu_purchase.add_items(menu_items)

    return menu_purchase    

  end
  
end
