class InstructorSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :picture, :picture_2, :quote, :bio, :active, :weekly_schedules

  def email
    object.admin_user.email
  end
  
  def weekly_schedules
    ActiveModel::ArraySerializer.new(object.schedules.includes(:room).where("datetime >= ? AND datetime <= ?", Time.zone.now, Time.zone.now + 7.days), each_serializer: ScheduleSerializer, except: :instructor)
  end
end
