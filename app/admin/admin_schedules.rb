ActiveAdmin.register Schedule, :as => "Clases" do

  actions :all

  permit_params :datetime, :room_id, :instructor_id

  config.filters = false
  
  config.sort_order = "datetime_asc"

  index :title => "Clases" do
    column "Horario", :datetime
    column "Instructor" do |schedule|
      "#{schedule.instructor.first_name} #{schedule.instructor.last_name}"
    end
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
      row "Instructor" do
        "#{schedule.instructor.first_name} #{schedule.instructor.last_name}"
      end
      row "Registrados" do
        schedule.appointments.map { |appointment| "#{appointment.user.first_name} #{appointment.user.last_name}" }.join("<br/>").html_safe
      end
    end
  end

  form do |f|
    f.inputs "Detalles de clases" do
      f.input :datetime, label: "Horario"
      f.input :instructor, label: "Instructor", :collection => Instructor.all, :as => :select, :member_label => Proc.new { |i| "#{i.first_name} #{i.last_name}" } 
      f.input :room, label: "Cuarto", :collection => Room.all, :as => :select, :member_label => Proc.new { |r| "#{r.description}" } 
    end
    f.actions
  end

end
