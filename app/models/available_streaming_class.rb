class AvailableStreamingClass < ActiveRecord::Base
  belongs_to :user
  belongs_to :streaming_class

  scope :playable, -> {where("start >= ?", (Time.zone.now - Configuration.playable_hours.hours))} 
  
  def self.purchase streaming_class_id, user

    streaming_class = StreamingClass.find(streaming_class_id)

    if not streaming_class.active
      raise "Clase no disponible."
    end
    if user.streaming_classes_left <= 0
      raise "Ya no tienes clases streaming disponibles, adquiere más para continuar."
    end
    if not user.available_streaming_classes.playable.select{|asc| asc.streaming_class_id == streaming_class_id.to_i}.empty?
      raise "No necesitas comprar esa clase, ya la tienes disponible."
    end

    available_streaming_class = AvailableStreamingClass.create!(start: Time.zone.now, user: user, streaming_class: streaming_class)
    user.update_attribute(:streaming_classes_left, user.streaming_classes_left - 1)
    
    available_streaming_class
  end
  
end
