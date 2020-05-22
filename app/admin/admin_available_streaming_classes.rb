ActiveAdmin.register StreamingClass, as: "Compras Streaming" do

  menu parent: 'Compras', priority: 1 

  actions :index

  filter :title, :label => "Título"
  filter :description, :label => "Descripción"
  filter :length, label: "Duración"
  filter :instructor_first_name, :label => "Nombre de instructor", :as => :string
  filter :active, label: "Activo"

  config.sort_order = "purchases_desc"  

  scope("#{Date::MONTHNAMES[(Time.zone.now.beginning_of_month - 3.month).month]}"){|scope| scope.where("available_streaming_classes.start >= ? AND available_streaming_classes.start <= ?", Time.zone.now.beginning_of_month - 3.month, Time.zone.now.end_of_month - 3.month)}
  
  scope("#{Date::MONTHNAMES[(Time.zone.now.beginning_of_month - 2.month).month]}"){|scope| scope.where("available_streaming_classes.start >= ? AND available_streaming_classes.start <= ?", Time.zone.now.beginning_of_month - 2.month, Time.zone.now.end_of_month - 2.month)}
  
  scope("#{Date::MONTHNAMES[(Time.zone.now.beginning_of_month - 1.month).month]}"){|scope| scope.where("available_streaming_classes.start >= ? AND available_streaming_classes.start <= ?", Time.zone.now.beginning_of_month - 1.month, Time.zone.now.end_of_month - 1.month)}
  
  scope("#{Date::MONTHNAMES[(Time.zone.now.beginning_of_month).month]}"){|scope| scope.where("available_streaming_classes.start >= ? AND available_streaming_classes.start <= ?", Time.zone.now.beginning_of_month, Time.zone.now.end_of_month)}
  
  scope("All"){|scope| scope}

  controller do
    def scoped_collection
      StreamingClass.select("streaming_classes.*, COUNT(available_streaming_classes.id) purchases").joins("LEFT OUTER JOIN available_streaming_classes ON available_streaming_classes.streaming_class_id = streaming_classes.id").group("streaming_classes.id")
    end
  end

  index title: "Compras Streaming" do
    column "Título", :title
    column "Descripción", :description
    column "Instructor" do |streaming|
      "#{streaming.instructor.first_name} #{streaming.instructor.last_name}" if streaming.instructor
    end
    column "Duración", :length
    column "Compras", sortable: :purchases do |streaming|
      streaming["purchases"]
    end
    column "Activo", :active
    
    actions defaults: true
  end
  
end
