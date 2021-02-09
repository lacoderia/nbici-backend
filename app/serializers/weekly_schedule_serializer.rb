module WeeklyScheduleSerializer

  def WeeklyScheduleSerializer.serialize(schedules_with_start_date, with_instructor = true)

    result = {}
    if with_instructor
      result[:schedules] = ActiveModel::ArraySerializer.new(schedules_with_start_date[:schedules], each_serializer: ScheduleSerializer) 
    else
      result[:schedules] = ActiveModel::ArraySerializer.new(schedules_with_start_date[:schedules], each_serializer: ScheduleSerializer, except: :instructor) 
    end
    result[:start_day] = schedules_with_start_date[:start_day]
    result[:venues] = Venue.all.select(:id, :name, :style)
    result
  end

end
