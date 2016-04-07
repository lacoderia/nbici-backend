class NbiciMailer < ActionMailer::Base
  default from: "\"n-bici\" <contacto@n-bici.mx>"

  def welcome user
    @user = user
    mail(to: @user.email, subject: "¡Bienvenido a n-bici!")
  end

  def booking appointment
    @user = appointment.user
    @appointment = appointment
    mail(to: @user.email, subject: "Tu clase ha sido reservada")
  end

  def purchase purchase
    @user = purchase.user
    @purchase = purchase
    mail(to: @user.email, subject: "Confirmación de compra")
  end

  def classes_left_reminder user
    @user = user
    mail(to: @user.email, subject: "Tus clases están por terminarse")
  end

  def expiration_reminder user
    @user = user
    mail(to: @user.email, subject: "Tus clases expirarán pronto")
  end

end
