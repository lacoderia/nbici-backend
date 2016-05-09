ActiveAdmin.register Appointment, :as => "Clientes_del_dia" do 
  
  actions :all, :except => [:show, :new, :destroy, :update, :edit]

  filter :start, :as => :date_time_range, :label => "Horario", datepicker_options: {min_date: Time.zone.now.beginning_of_day, max_date: Time.zone.now.end_of_day}
  
  filter :schedule_instructor_first_name, :as => :string, :label => "Nombre del instructor"
  
  filter :user_last_name, :as => :string, :label => "Apellido de cliente"

  config.sort_order = 'start_asc, bicycle_number_asc'

  controller do
    def scoped_collection
      Appointment.today_with_users
    end
  end

  index :title => "Clientes del dia" do
    column "Horario", :start
    column "Bicicleta", :bicycle_number
    column 'Nombre' do |appointment|
      "#{appointment.user.first_name} #{appointment.user.last_name}"
    end
    column 'Instructor' do |appointment|
      "#{appointment.schedule.instructor.first_name} #{appointment.schedule.instructor.last_name}"
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
