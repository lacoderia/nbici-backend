class AppointmentSerializer < ActiveModel::Serializer

  attributes :id, :user_id, :schedule_id, :bicycle_number, :status, :start, :description, :anomaly, :booked_seats

  def booked_seats
    object.schedule.bookings
  end

end
