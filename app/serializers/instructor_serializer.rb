class InstructorSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :picture, :quote, :bio, :weekly_schedules

  def weekly_schedules
    object.schedules.where("datetime >= ? AND datetime <= ?", Time.zone.now, Time.zone.now + 7.days)
  end
end
