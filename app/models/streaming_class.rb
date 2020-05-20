class StreamingClass < ActiveRecord::Base
  belongs_to :instructor
  
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

end
