class NbiciMailer < ActionMailer::Base
  default from: "\"n-bici\" <contacto@n-bici.com>", reply_to: "Geor Nbici <geor@n-bici.com>" 

  def welcome user, data = nil
    @user = user
    mail(to: @user.email, subject: "¡Bienvenido a n-bici!")
  end

  def booking user, appointment
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

end
