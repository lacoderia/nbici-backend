class NbiciMailer < ActionMailer::Base
  default from: "\"n-bici\" <contacto@n-bici.mx>"

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

  def send_email email_name, user, data
    begin
      mail = NbiciMailer.send(email_name, user, obj)
      mail.deliver_now
      Email.create(user: user, email_status: "sent", email_type: email_name.to_s)
    rescue
      Email.create(user: user, email_status: "error", email_type: email_name.to_s)
    end
  end

end
