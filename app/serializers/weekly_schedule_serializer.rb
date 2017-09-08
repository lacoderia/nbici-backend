module WeeklyScheduleSerializer

  def WeeklyScheduleSerializer.serialize(schedules_with_start_date)

    result = {}
    result[:schedules] = ActiveModel::ArraySerializer.new(schedules_with_start_date[:schedules], each_serializer: ScheduleSerializer, except: :instructor) 
    result[:start_day] = schedules_with_start_date[:start_day]
    result
  end

end
