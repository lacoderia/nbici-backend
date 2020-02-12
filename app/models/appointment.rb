class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :schedule
  has_many :menu_purchases

  STATUSES = [
    'BOOKED',
    'CANCELLED',
    'FINALIZED',
    'ANOMALY'
  ]
  
  validates :status, inclusion: {in: STATUSES}
  
  state_machine :status, :initial => 'BOOKED' do
    transition 'BOOKED' => 'FINALIZED', on: :finalize
    transition 'BOOKED' => 'CANCELLED', on: :cancel
    transition 'FINALIZED' => 'ANOMALY', on: :report_anomaly
  end

  scope :today_with_users, -> {where("start >= ? AND start <= ?", Time.zone.now.beginning_of_day, Time.zone.now.end_of_day).includes(:user, :schedule => :instructor)}
  scope :all_with_users_and_schedules, ->{includes(:user, :schedule => :instructor)}
  scope :not_cancelled_with_users_and_schedules, ->{where("status != ?", 'CANCELLED').includes(:user, :schedule => :instructor)}
  scope :booked, -> {where("status = ?", 'BOOKED')}
  scope :finalized, -> {where("status = ?", 'FINALIZED')}
  scope :cancelled, -> {where("status = ?", 'CANCELLED')}
  scope :not_cancelled, -> {where("status = ? OR status = ?", 'BOOKED', 'FINALIZED')}
  #scope :today_with_users, -> {where("true").includes(:user, :schedule=> :instructor)}

  def cancel_with_time_check current_user, no_time_check = false
    if current_user.test? or no_time_check
      if Time.zone.now < (self.start - 1.minute)
        self.cancel!
        if self.user.classes_left and (not self.schedule.free)
          if self.schedule.opening 
            future_free_appointments = current_user.appointments.not_cancelled.joins(:schedule).where("schedules.datetime between ? and ? and schedules.opening = ?", Configuration.free_classes_start_date, Configuration.free_classes_end_date, true)
            if not future_free_appointments.empty?
              self.user.update_attribute(:classes_left, self.user.classes_left + 1) 
            end
          else
            self.user.update_attribute(:classes_left, self.user.classes_left + 1) 
          end
        end

        if self.menu_purchases.count > 0
          self.menu_purchases.each do |menu_purchase|
            menu_purchase.cancel!
          end
        end
      else
        raise "Sólo se pueden cancelar clases con usuario de pruebas con 1 minuto de anticipación."
      end
    else
      if Time.zone.now < (self.start - 12.hours)
        self.cancel!
        if self.user.classes_left and (not self.schedule.free)
          if self.schedule.opening 
            future_free_appointments = current_user.appointments.not_cancelled.joins(:schedule).where("schedules.datetime between ? and ? and schedules.opening = ?", Configuration.free_classes_start_date, Configuration.free_classes_end_date, true)
            if not future_free_appointments.empty?
              self.user.update_attribute(:classes_left, self.user.classes_left + 1) 
            end
          else
            self.user.update_attribute(:classes_left, self.user.classes_left + 1) 
          end
        end
        
        if self.menu_purchases.count > 0
          self.menu_purchases.each do |menu_purchase|
            menu_purchase.cancel!
          end
        end
      else
        raise "Sólo se pueden cancelar clases con 12 horas de anticipación."
      end
    end
        
  end

  def edit_bicycle_number bicycle_number
    
    if not self.schedule.bicycle_exists?(bicycle_number)
      raise "Esa bicicleta no existe, por favor intenta nuevamente."
    end
      
    if self.schedule.bookings.find{|bicycle| bicycle.number == bicycle_number}
      raise "La bicicleta ya fue reservada, por favor intenta con otra."
    end

    if Time.zone.now < (self.start - 1.hour)
      self.update_attribute(:bicycle_number, bicycle_number)
    else
      raise "Sólo se pueden cambiar los lugares con al menos una hora de anticipación."
    end
  end

  def self.finalize
    appointments_to_finalize = Appointment.where("status = ? AND start < ?", "BOOKED", Time.zone.now - 1.hour)
    appointments_to_finalize.each do |appointment|
      appointment.finalize!
      if appointment.user.appointments.finalized.count == 1
        SendEmailJob.perform_later("after_first_class", appointment.user, appointment)
      end
    end
  end

  def self.book_and_charge params, current_user
    #schedule data
    schedule = Schedule.find(params[:schedule_id])
    bicycle_number = params[:bicycle_number].to_i
    description = params[:description]
    appointment = Appointment.new

    if schedule.datetime <= Time.zone.now
      raise "La clase ya está fuera de horario."
    end
      
    if not schedule.bicycle_exists?(bicycle_number)
      raise "Esa bicicleta no existe, por favor intenta nuevamente."
    end    

    if (not schedule.bookings.find{|bicycle| bicycle.number == bicycle_number})

      if schedule.price.nil?
        raise "Esta clase especial necesita tener un precio asignado."
      else

        if(not schedule.bookings.find{|bicycle| bicycle.number == bicycle_number})

          if not current_user.test?
          
            #charge data
            amount = params[:price].to_i * 100
            card = Card.find_by_uid(params[:uid]) 
          
            if not card
              raise "Tarjeta no encontrada o registrada."
            end
          
            description = "Compra de clase de aniversario"
            currency = "MXN"
            params_price = params[:price]

            if params[:price].to_f != schedule.price.to_f
              raise "El precio enviado es diferente al precio de la clase paquete."
            end

            charge = Conekta::Charge.create({
              amount: amount,
              currency: currency,
              description: description,
              card: card.uid,
              details: {
                name: card.name,
                email: current_user.email,
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
              user: current_user,
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

          schedule.appointments << appointment = Appointment.create!(user: current_user, schedule: schedule, bicycle_number: bicycle_number, status: "BOOKED", start: schedule.datetime, description: description)
          return appointment
          
        elsif schedule.bookings.find{|station| station.number == station_number}
          raise "La bicicleta ya fue reservada, por favor intenta con otra."
        end
      end

    else
      raise "La bicicleta ya fue reservada, por favor intenta con otra."
    end
    
  end

  def self.book params, current_user

    schedule = Schedule.find(params[:schedule_id])
    bicycle_number = params[:bicycle_number].to_i
    description = params[:description]
    appointment = Appointment.new
    
    if schedule.datetime <= Time.zone.now
      raise "La clase ya está fuera de horario."
    end
      
    if not schedule.bicycle_exists?(bicycle_number)
      raise "Esa bicicleta no existe, por favor intenta nuevamente."
    end
    
    if (not schedule.bookings.find{|bicycle| bicycle.number == bicycle_number})
      if schedule.opening
        future_free_appointments = current_user.appointments.not_cancelled.joins(:schedule).where("schedules.datetime between ? and ? and schedules.opening = ?", Configuration.free_classes_start_date, Configuration.free_classes_end_date, true)
        if future_free_appointments.empty?
          schedule.appointments << appointment = Appointment.create!(user: current_user, schedule: schedule, bicycle_number: bicycle_number, status: "BOOKED", start: schedule.datetime, description: description)
        else
          #The second opening class will be deducted
          if (current_user.classes_left and current_user.classes_left >= 1) and (not schedule.bookings.find{|bicycle| bicycle.number == bicycle_number})
            schedule.appointments << appointment = Appointment.create!(user: current_user, schedule: schedule, bicycle_number: bicycle_number, status: "BOOKED", start: schedule.datetime, description: description)      
            current_user.update_attribute(:classes_left, current_user.classes_left - 1)
          elsif not current_user.classes_left or current_user.classes_left == 0 
            raise "Ya no tienes clases disponibles, adquiere más para continuar."
          elsif schedule.bookings.find{|station| station.number == station_number}
            raise "La bicicleta ya fue reservada, por favor intenta con otra."
          end
        end

      elsif schedule.free
        free_appointments = current_user.appointments.booked.where("schedule_id = ?", schedule.id)
        if free_appointments.empty?
          schedule.appointments << appointment = Appointment.create!(user: current_user, schedule: schedule, bicycle_number: bicycle_number, status: "BOOKED", start: schedule.datetime, description: description)
        else
          raise "Sólo puedes reservar un lugar en clases gratis."
        end
      else
        if (current_user.classes_left and current_user.classes_left >= 1) and (not schedule.bookings.find{|bicycle| bicycle.number == bicycle_number})
          schedule.appointments << appointment = Appointment.create!(user: current_user, schedule: schedule, bicycle_number: bicycle_number, status: "BOOKED", start: schedule.datetime, description: description)      
          current_user.update_attribute(:classes_left, current_user.classes_left - 1)
        elsif not current_user.classes_left or current_user.classes_left == 0 
          raise "Ya no tienes clases disponibles, adquiere más para continuar."
        elsif schedule.bookings.find{|station| station.number == station_number}
          raise "La bicicleta ya fue reservada, por favor intenta con otra."
        end
      end
    else
      raise "La bicicleta ya fue reservada, por favor intenta con otra."
    end
    
    appointment
  end

  def self.weekly_scope_for_user current_user
    start_day = Time.zone.now
    Appointment.where("user_id = ? AND start >= ?", current_user.id, start_day).to_a
  end

  def self.historic_for_user current_user
    start_day = Time.zone.now
    Appointment.where("user_id = ? AND start < ?", current_user.id, start_day).limit(25).order(id: :desc).to_a    
  end
end
