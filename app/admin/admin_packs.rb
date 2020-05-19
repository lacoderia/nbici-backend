ActiveAdmin.register Pack, :as => "Paquetes" do
  
  menu parent: 'Operacion Interna', priority: 0 
	
  actions :all, :except => [:show, :destroy]

  permit_params :classes, :description, :price, :special_price, :expiration, :active, :streaming_classes

  config.filters = false

  index :title => "Paquetes" do
    column "Descripción", :description
    column "Clases", :classes
    column "Clases streaming", :streaming_classes
    column "Precio", :price
    column "Precio especial", :special_price
    column "Días de expiración", :expiration
    column "Activo", :active
    actions :defaults => true
  end

  form do |f|

    classes_input_html =  {id: "classes_id", onkeyup: "if(this.value){ $('#streaming_classes_id')[0].readOnly=true; $('#streaming_classes_id')[0].style = 'background-color: #d3d3d3;'; $('#streaming_classes_id')[0].value=null } else { $('#streaming_classes_id')[0].readOnly=false; $('#streaming_classes_id')[0].style = 'background-color: #FFFFFF;'; }"}
    streaming_classes_input_html = {id: "streaming_classes_id", onkeyup: "if(this.value){ $('#classes_id')[0].readOnly=true; $('#classes_id')[0].style = 'background-color: #d3d3d3;'; $('#classes_id')[0].value=null } else { $('#classes_id')[0].readOnly=false; $('#classes_id')[0].style = 'background-color: #FFFFFF;'; }"}

    if f.object.classes
      streaming_classes_input_html[:readOnly] = true
      streaming_classes_input_html[:style] = "background-color: #d3d3d3;"
    elsif f.object.streaming_classes
      classes_input_html[:readOnly] = true
      classes_input_html[:style] = "background-color: #d3d3d3;"
    end

    f.inputs "Detalles de paquetes" do
      f.input :description, label: "Descripción"
      f.input :classes, label: "Clases", input_html: classes_input_html
      f.input :streaming_classes, label: "Clases streaming", input_html: streaming_classes_input_html
      f.input :price, label: "Precio"
      f.input :special_price, label: "Precio especial"
      f.input :expiration, label: "Días de expiración"
      f.input :active, label: "Activo"
    end
    f.actions
  end

end
