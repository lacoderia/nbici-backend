class StreamingClass < ActiveRecord::Base
  belongs_to :instructor
  has_many :available_streaming_classes

  has_attached_file :photo, styles: { original: "960x540>", thumb: "300x168>" }
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

  after_save :verify_featured

  scope :active, -> {where(active: true).order(featured: :desc, created_at: :desc)}

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

  private

  def verify_featured
    if self.featured
      featured_classes = StreamingClass.where("featured = ? AND id != ?", true, self.id)
      if not featured_classes.empty?
        if featured_classes.size > 1
          featured_classes.update_all(featured: false)
        else
          featured_classes.first.update_attribute("featured", false)
        end
      end
    end
  end

end
