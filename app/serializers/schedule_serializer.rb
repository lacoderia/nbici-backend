class ScheduleSerializer < ActiveModel::Serializer

  attributes :id, :datetime, :room, :instructor, :available_seats

  def room
    room_obj = {}
    room_obj[:id] = object.room.id
    room_obj[:description] = object.room.description
    room_obj[:venue] = object.room.venue
    room_obj
  end

  def available_seats
    object.available_seats
  end
  
  def instructor
    object.instructor
  end

end
