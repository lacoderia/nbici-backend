ActiveAdmin.register Pack, :as => "Paquetes" do
	
  actions :all, :except => [:show]

  permit_params :classes, :description, :price, :special_price, :expiration 

  config.filters = false

  index :title => "Paquetes" do
    column "Descripción", :description
    column "Clases", :classes
    column "Precio", :price
    column "Precio especial", :special_price
    column "Días de expiración", :expiration
    actions :defaults => true
  end

  form do |f|
    f.inputs "Detalles de paquetes" do
      f.input :description, label: "Descripción"
      f.input :classes, label: "Clases"
      f.input :price, label: "Precio"
      f.input :special_price, label: "Precio especial"
      f.input :expiration, label: "Días de expiración"
    end
    f.actions
  end

end
