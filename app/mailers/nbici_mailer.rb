class NbiciMailer < ActionMailer::Base
  default from: "\"n-bici\" <contacto@n-bici.com>", reply_to: "Geor Nbici <geor@n-bici.com>" 

  def welcome user, data = nil
    @user = user
    mail(to: @user.email, subject: "¡Bienvenido a N bici!")
  end

  def booking user, appointment
    @user = user
    @appointment = appointment
    mail(to: @user.email, subject: "Tu clase ha sido reservada")
  end

  def waitlist user, waitlist
    @user = user
    @waitlist = waitlist
    mail(to: @user.email, subject: "Te has unido a la lista de espera")
  end

  def reimburse user, waitlist
    @user = user
    @waitlist = waitlist
    mail(to: @user.email, subject: "Reembolso de lista de espera")
  end

  def streaming_booking user, available_streaming_class
    @user = user
    @available_streaming_class = available_streaming_class
    mail(to: @user.email, subject: "Tu clase en streaming con #{@available_streaming_class.streaming_class.instructor.first_name} está disponible")
  end

  def booking_anniversary user, appointment
    @user = user
    @appointment = appointment
    mail(to: @user.email, subject: "Tu clase ha sido reservada")
  end

  def purchase user, purchase
    @user = user
    @purchase = purchase
    mail(to: @user.email, subject: "Confirmación de compra")
  end

  def streaming_purchase user, purchase
    @user = user
    @purchase = purchase
    mail(to: @user.email, subject: "Confirmación de compra")
  end

  def classes_left_reminder user, data = nil
    @user = user
    mail(to: @user.email, subject: "Tus clases están por terminarse")
  end

  def expiration_reminder user, data = nil
    @user = user
    mail(to: @user.email, subject: "Tus clases expirarán pronto")
  end

  def send_coupon user, email
    @user = user
    mail(to: email, subject: "¡#{@user.first_name} te invita a probar N Bici!")
  end

  def after_first_class user, appointment
    @user = user
    @appointment = appointment
    mail(to: @user.email, subject: "¿Cómo te fue en tu primera clase?")
  end

  def shared_coupon referred, referrer 
    @referred = referred
    mail(to: referrer.email, subject: "¡Tienes saldo a favor!")
  end

  def credit_modifications user, credit_modification
    @user = user
    @credit_modification = credit_modification
    mail(to: @user.email, subject: "#{@user.first_name}, tus modificaciones desde recepción")    
  end

  def front_desk_purchase user, purchase
    @user = user
    @purchase = purchase
    mail(to: @user.email, subject: "#{@user.first_name}, tu compra desde recepción")
  end

  def menu_purchase user, menu_purchase
    @user = user
    @purchase = menu_purchase
    mail(to: @user.email, subject: "#{@user.first_name}, tu compra Dafit")
  end

  def menu_purchase_admin admin_email, menu_purchase
    @user = menu_purchase.user 
    @purchase = menu_purchase
    mail(to: admin_email, subject: "#{@user.first_name}, hizo una compra para #{@purchase.schedule.datetime.strftime("%d/%m/%Y %I:%M%p")}")
  end

end
