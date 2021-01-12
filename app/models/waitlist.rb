class Waitlist < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :user

  STATUSES = [
    ['EN ESPERA', 'WAITING'],
    ['ASIGNADA', 'ASSIGNED'],
    ['REEMBOLSADA', 'REIMBURSED']
  ]

  validates :status, inclusion: {in: STATUSES.map{|pairs| pairs[1]}}

  accepts_nested_attributes_for :user

  state_machine :status, :initial => 'WAITING' do
    transition 'WAITING' => 'ASSIGNED', on: :assign
    transition 'WAITING' => 'REIMBURSED', on: :reimburse
  end

  def self.reimburse_classes
    waitlists_to_reimburse = Waitlist.joins(:schedule).where("waitlists.status = ? AND schedules.datetime < ?", "WAITING", Time.zone.now - 1.hour)
    waitlists_to_reimburse.each do |waitlist|
      if waitlist.schedule.price?
        waitlist.user.update_attribute("credits", waitlist.user.credits + waitlist.schedule.price)
      else
        waitlist.user.update_attribute("classes_left", waitlist.user.classes_left + 1)
      end
      waitlist.reimburse!
      SendEmailJob.perform_later("reimburse", waitlist.user, waitlist)
    end
  end

  def self.create_charge_and_send_email(schedule_id, price, uid, user)

    schedule = Schedule.find(schedule_id)

    #full validation
    if schedule.available_seats > 0
      raise "La clase todavía tiene asientos disponibles."
    end

    #already in wishlist validation
    if not schedule.waitlists.where(user: user).empty?
      raise "Ya estás registrado en la lista de espera."
    end

    #time validation
    if Time.zone.now < (schedule.datetime - 12.hours)

      if not user.test?

        #charge data
        amount = price.to_i * 100
        card = Card.find_by_uid(uid)

        if not card
          raise "Tarjeta no encontrada o registrada."
        end

        description = "Compra de lista de espera"
        currency = "MXN"

        if price.to_f != schedule.price.to_f
          raise "El precio enviado es diferente al precio de la clase paquete."
        end

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
              description: "Lista de espera para clase especial nbici",
              unit_price: amount,
              quantity: 1
            }]
          }
        })

        purchase = Purchase.create!(
          user: user,
          uid: charge.id,
          object: charge.object,
          livemode: charge.livemode,
          status: charge.status,
          description: charge.description,
          amount: charge.amount,
          currency: charge.currency,
          payment_method: charge.payment_method,
          details: charge.details,
        )

      end

      waitlist = Waitlist.create!(schedule: schedule, user: user, status: "WAITING")
      SendEmailJob.perform_later("waitlist", user, waitlist)
      return waitlist
    else
      raise "Sólo se puede ingresar a lista de espera con al menos 12 horas de anticipación."
    end

  end

  def self.create_and_send_email(schedule_id, user)

    schedule = Schedule.find(schedule_id)

    if not schedule.price.nil?
      raise "Esta lista de espera tiene un precio especial."
    end

    #credit validation
    if (not schedule.free) and (not user.classes_left or user.classes_left == 0)
      raise "Ya no tienes clases disponibles, adquiere más para continuar."
    end

    #full validation
    if schedule.available_seats > 0
      raise "La clase todavía tiene asientos disponibles."
    end

    #already in wishlist validation
    if not schedule.waitlists.where(user: user).empty?
      raise "Ya estás registrado en la lista de espera."
    end

    #time validation
    if Time.zone.now < (schedule.datetime - 12.hours)
      user.update_attribute(:classes_left, user.classes_left - 1)
      waitlist = Waitlist.create!(schedule: schedule, user: user, status: "WAITING")
      SendEmailJob.perform_later("waitlist", user, waitlist)
      return waitlist
    else
      raise "Sólo se puede ingresar a lista de espera con al menos 12 horas de anticipación."
    end

  end
end
