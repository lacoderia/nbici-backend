class WaitlistSerializer < ActiveModel::Serializer

  attributes :id, :user_id, :schedule, :status, :show_menu

  def show_menu
    Configuration.show_menu?(object.schedule.datetime)
  end

  def schedule
    sch_obj = {}
    sch_obj[:id] = object.schedule.id
    sch_obj[:datetime] = object.schedule.datetime
    sch_obj[:room_id] = object.schedule.room_id
    sch_obj[:description] = object.schedule.description
    sch_obj[:instructor] = object.schedule.instructor
    sch_obj[:free] = object.schedule.free
    sch_obj[:opening] = object.schedule.opening
    sch_obj
  end

end
