module BookingsSerializer

  def BookingsSerializer.serialize(booked_seats)
    return if booked_seats.nil?

    bookings = {}
    bookings[:bookings] = {booked_seats: booked_seats.to_s}
    bookings
  end

end
