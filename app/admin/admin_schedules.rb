ActiveAdmin.register Schedule, :as => "Presenciales" do

  menu parent: 'Clases', priority: 0    

  actions :all

  permit_params :datetime, :room_id, :instructor_id, :description, :opening, :free, :alternate_instructor_id, :price

  filter :datetime, :label => "Horario"
  filter :description, :label => "Descripción"
  filter :free, :label => "Gratis"
  filter :opening, :label => "Apertura"
  filter :instructor_first_name, :label => "Nombre de instructor", :as => :string
  filter :instructor_active, :label => "¿Instructor activo?", :as => :boolean
  
  config.sort_order = "datetime_desc"

  index :title => "Clases" do
    column "Horario", :datetime
    column "Instructor" do |schedule|
      "#{schedule.instructor.first_name} #{schedule.instructor.last_name}" if schedule.instructor
    end
    column "Suple a" do |schedule|
      "#{schedule.alternate_instructor.first_name} #{schedule.alternate_instructor.last_name}" if schedule.alternate_instructor
    end
    column "Descripción", :description
    column "Reservados" do |schedule|
      schedule.appointments.booked.count
    end
    column "Cancelados" do |schedule|
      schedule.appointments.cancelled.count
    end
    column "Confirmados" do |schedule|
      schedule.appointments.finalized.count
    end
    column "Por Pagar" do |schedule|
      Configuration.payment_based_on_attendees schedule.appointments.finalized.count
    end
    column "Gratis", :free
    column "Apertura", :opening
    column "Costo aniversario", :price
    
    actions defaults: false do |schedule|
      links = "#{link_to "View", admin_presenciale_path(schedule.id)} "
      links += "#{link_to "Edit", "#{admin_presenciale_path(schedule.id)}/edit"} "
      if schedule.appointments.not_cancelled.empty?
        links += "#{link_to "Delete", admin_presenciale_path(schedule.id), method: :delete, data: {:confirm => "Eliminarás la clase. ¿Estás seguro?"} }"
      end
      links.html_safe
    end
  end

  csv do
    column "Horario" do |schedule|
      schedule.datetime
    end
    column "Instructor" do |schedule|
      "#{schedule.instructor.first_name} #{schedule.instructor.last_name}" if schedule.instructor
    end
    column "Suple a" do |schedule|
      "#{schedule.alternate_instructor.first_name} #{schedule.alternate_instructor.last_name}" if schedule.alternate_instructor
    end
    column "Descripcion" do |schedule| 
      schedule.description
    end
    column "Reservados" do |schedule|
      schedule.appointments.booked.count
    end
    column "Cancelados" do |schedule|
      schedule.appointments.cancelled.count
    end
    column "Confirmados" do |schedule|
      schedule.appointments.finalized.count
    end
    column "Por Pagar" do |schedule|
      Configuration.payment_based_on_attendees schedule.appointments.finalized.count
    end
  end

  show do |schedule|
    attributes_table do
      row "Horario" do
        schedule.datetime
      end
      row "Instructor" do
        "#{schedule.instructor.first_name} #{schedule.instructor.last_name}" if schedule.instructor
      end
      row "Suple a" do
        "#{schedule.alternate_instructor.first_name} #{schedule.alternate_instructor.last_name}" if schedule.alternate_instructor
      end
      row "Descripción" do
        schedule.description
      end
      row "Reservados" do
        schedule.appointments.booked.map { |appointment| "#{appointment.user.first_name} #{appointment.user.last_name}" if appointment.user }.join("<br/>").html_safe
      end
      row "Cancelados" do
        schedule.appointments.cancelled.map { |appointment| "#{appointment.user.first_name} #{appointment.user.last_name}" if appointment.user  }.join("<br/>").html_safe
      end
      row "Confirmados" do
        schedule.appointments.finalized.map { |appointment| "#{appointment.user.first_name} #{appointment.user.last_name}"if appointment.user  }.join("<br/>").html_safe
      end
      row "Por Pagar" do
        Configuration.payment_based_on_attendees schedule.appointments.finalized.count
      end
    end
  end

  form do |f|
    f.inputs "Detalles de clases" do
      f.input :datetime, label: "Horario"
      f.input :instructor, label: "Instructor", :collection => Instructor.active.collect{|i| [ "#{i.first_name} #{i.last_name}", i.id]}, :as => :select, :include_blank => false 
      f.input :alternate_instructor, label: "Suple a", :collection => Instructor.active.collect{|i| [ "#{i.first_name} #{i.last_name}", i.id]}, :as => :select 
      f.input :room, label: "Cuarto", :collection => Room.all.collect{|room| ["#{room.venue.name} - #{room.description}", room.id]}, :as => :select, :include_blank => false 
      f.input :description, label: "Descripción"
      f.input :free, label: "Gratis"
      f.input :opening, label: "Apertura"
      f.input :price, label: "Costo aniversario"
    end
    f.actions
  end

end
