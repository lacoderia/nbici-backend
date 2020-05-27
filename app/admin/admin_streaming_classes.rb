ActiveAdmin.register StreamingClass, as: "Streaming" do

  menu parent: 'Clases', priority: 1

  actions :all, except: :destroy
  
  permit_params :title, :description, :instructor_id, :photo, :length, :insertion_code, :active, :intensity, :featured 

  filter :title, :label => "Título"
  filter :description, :label => "Descripción"
  filter :intensity, :label => "Intensidad"
  filter :length, label: "Duración"
  filter :instructor_first_name, :label => "Nombre de instructor", :as => :string
  filter :instructor_active, :label => "¿Instructor activo?", :as => :boolean

  index title: "Streamings" do
    column "Título", :title
    column "Descripción", :description
    column "Instructor" do |streaming|
      "#{streaming.instructor.first_name} #{streaming.instructor.last_name}" if streaming.instructor
    end
    column "Duración", :length
    column "Intensidad", :intensity
    column "Código inserción", :insertion_code
    column "Foto", :photo do |streaming|
      image_tag streaming.photo.url(:thumb)
    end
    column "Especial", :featured
    column "Activo", :active
    actions defaults: true
  end

  form do |f|
    f.inputs "Detalles de streaming" do
      f.input :title, label: "Título"
      f.input :description, label: "Descripción"
      f.input :instructor, label: "Instructor", :collection => Instructor.active.collect{|i| [ "#{i.first_name} #{i.last_name}", i.id]}, :as => :select, :include_blank => false 
      f.input :length, label: "Duración", as: :select, collection: StreamingClass::LENGTHS, :include_blank => false
      f.input :insertion_code, label: "Código inserción"
      f.input :intensity, label: "Intensidad"
      f.input :photo, :as => :file
      f.input :featured, label: "Especial"
      f.input :active, label: "Activo"
    end
    f.actions
  end	


end
