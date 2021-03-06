ActiveAdmin.register Appointment, :as => "Cancelar_reservaciones" do 

  menu parent: 'Reservaciones', priority: 1 
  
  actions :all, :except => [:show, :new, :update, :edit]

  filter :start, :as => :date_time_range, :label => "Horario"  
  filter :schedule_instructor_first_name, :as => :string, :label => "Nombre del instructor"  
  filter :user_last_name, :as => :string, :label => "Apellido de cliente"

  config.sort_order = 'start_desc, bicycle_number_asc'

  controller do
    def scoped_collection
      Appointment.not_cancelled_with_users_and_schedules
    end

    def destroy
      appointment = Appointment.find(params[:id]) 
      
      appointment.cancel_with_time_check(appointment.user, true)
      flash[:notice] = "Appointment cancelled correctly."
        redirect_to collection_url and return
    end
    
  end

  index :title => "Cancelar reservaciones" do
    column "Horario", :start
    column "Bicicleta", :bicycle_number
    column 'Nombre' do |appointment|
      "#{appointment.user.first_name} #{appointment.user.last_name}" if appointment.user
    end
    column 'Instructor' do |appointment|
      "#{appointment.schedule.instructor.first_name} #{appointment.schedule.instructor.last_name}" if appointment.schedule
    end
    actions defaults: false do |appointment|
      "#{link_to "Cancel", admin_cancelar_reservacione_path(appointment.id), method: :delete, data: {:confirm => "Cancelarás la reservación. ¿Estás seguro?"} }".html_safe
    end

  end

  csv do
    column "Horario" do |appointment|
      appointment.start
    end
    column "Bicicleta" do |appointment|
      appointment.bicycle_number
    end
    column 'Nombre' do |appointment|
      "#{appointment.user.first_name} #{appointment.user.last_name}"
    end
    column 'Instructor' do |appointment|
      "#{appointment.schedule.instructor.first_name} #{appointment.schedule.instructor.last_name}"
    end
  end

end

