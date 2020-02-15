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

  def menu_purchase_admin user, menu_purchase
    @user = user
    @purchase = menu_purchase
    email = Configuration.dafit_email.value
    mail(to: email, subject: "#{@user.first_name}, hizo una compra para #{@purchase.schedule.datetime.strftime("%d/%m/%Y %I:%M%p")}")
  end

end
