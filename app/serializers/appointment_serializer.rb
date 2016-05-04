class AppointmentSerializer < ActiveModel::Serializer

  attributes :id, :user_id, :schedule, :bicycle_number, :status, :start, :description, :anomaly, :booked_seats

  def booked_seats
    object.schedule.bookings
  end

  def schedule
    sch_obj = {}
    sch_obj[:id] = object.schedule.id
    sch_obj[:datetime] = object.schedule.datetime
    sch_obj[:room_id] = object.schedule.room_id
    sch_obj[:instructor] = object.schedule.instructor
    sch_obj
  end

end
