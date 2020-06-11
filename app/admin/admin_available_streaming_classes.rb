ActiveAdmin.register StreamingClass, as: "Compras Streaming" do

  menu parent: 'Compras', priority: 1 

  actions :index, :show

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
      streaming.purchases
    end
    column "Activo", :active

    actions defaults: false do |purchase|
      if params[:scope]
        link_to "Detalles", "#{admin_compras_streaming_path(purchase.id)}?scope=#{params[:scope]}"
      else
        link_to "Detalles", admin_compras_streaming_path(purchase.id)
      end
    end
    
  end

  show title: "Compras Streaming Detalles" do |streaming|

    if params[:scope]

      today = Date.today 
      scoped_beginning_of_month = "#{params[:scope]}/01/#{today.year}".to_date
      
      if today < scoped_beginning_of_month
        scoped_beginning_of_month -= 1.year
      end

      scoped_end_of_month = scoped_beginning_of_month.end_of_month

      available_streaming_classes = streaming.available_streaming_classes.where("available_streaming_classes.start >= ? AND available_streaming_classes.start <= ?", scoped_beginning_of_month, scoped_end_of_month)
    else
      available_streaming_classes = streaming.available_streaming_classes
    end

    attributes_table do
      row "Título" do
        streaming.title  
      end
      row "Descripción" do
        streaming.description  
      end
      row "Instructor" do
        "#{streaming.instructor.first_name} #{streaming.instructor.last_name}" if streaming.instructor
      end
      row "Duración" do
        streaming.length  
      end
      row "Activo" do
        streaming.active  
      end
      if params[:scope]
        row "month" do
          params[:scope].capitalize
        end
      end
      row "Compras Totales" do
        available_streaming_classes.count 
      end
      row "Compras por" do
        result = ""
        available_streaming_classes.each do |asc|
          result += "#{asc.user.email} - #{asc.user.first_name} #{asc.user.last_name} - #{asc.start.strftime("%d/%m/%Y %I:%M%p")}<br/>" 
        end
        result.html_safe
      end

    end

  end
  
end
