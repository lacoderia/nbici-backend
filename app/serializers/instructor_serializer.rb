class InstructorSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :picture, :picture_2, :quote, :bio, :active, :weekly_schedules

  def email
    object.admin_user.email
  end
    
  def weekly_schedules
    start_day = Time.zone.now
    end_day = start_day + 7.days
    schedules_with_start_date = Schedule.weekly_scope_with_parameters(object.schedules, start_day, end_day)
    WeeklyScheduleSerializer.serialize(schedules_with_start_date)
  end
end
