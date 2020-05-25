class StreamingClass < ActiveRecord::Base
  belongs_to :instructor
  has_many :available_streaming_classes  
  
  has_attached_file :photo, styles: { original: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  validates :photo, attachment_presence: true  
  validates :intensity, :inclusion => 1..3  
  validates :title, presence: true
  validates :instructor, presence: true
  validates :insertion_code, presence: true

  LENGTHS = [
    "30 minutos",
    "45 minutos",
    "60 minutos"
  ]

  scope :active, -> {where(active: true)}  

  def validate_availability(user)

    available_streaming_classes = user.available_streaming_classes.where(streaming_class: self) 
    available_streaming_class = available_streaming_classes.find{|asc| (asc.start + 24.hours) > Time.zone.now }

    if available_streaming_classes.empty? 
      raise "La clase no está disponible para este usuario."
    elsif not available_streaming_class
      raise "La clase ya cumplió su periodo de 24 horas de disponibilidad desde que la compraste."
    end

    available_streaming_class
  end

end
