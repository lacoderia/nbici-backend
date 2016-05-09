ActiveAdmin.register ScheduleForInstructor, :as => "Clases_de_entrenadores" do

  actions :all, :except => [:new, :destroy, :update, :edit]

  config.filters = false
  
  config.sort_order = "datetime_asc"
  
  controller do
    def scoped_collection
      ScheduleForInstructor.for_instructor(current_admin_user.instructor.id)
    end
  end

  index :title => "Clases programadas" do
    
    column "Horario", :datetime
    column "Número de registrados" do |schedule|
      schedule.appointments.booked.count
    end

    actions :defaults => true
  end

  show do |schedule|
    attributes_table do
      row "Horario" do
        schedule.datetime
      end
      row "Registrados" do
        schedule.appointments.map { |appointment| "#{appointment.user.first_name} #{appointment.user.last_name}" }.join("<br/>").html_safe
      end
    end
  end

end
