class Distribution < ActiveRecord::Base
  has_many :rooms

  def self.by_room_id room_id
    begin
      room = Room.find(room_id)
      return room.distribution
    rescue
      return nil
    end
  end
  
end
