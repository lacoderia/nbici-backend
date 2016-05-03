ActiveAdmin.register Pack, :as => "Paquetes" do
	
  actions :all, :except => [:show]

  permit_params :classes, :description, :price, :special_price, :expiration 

  config.filters = false

  index :title => "Paquetes" do
    column :description	
    column :classes
    column :price
    column :special_price
    column :expiration
    actions :defaults => true
  end

  form do |f|
    f.inputs "Detalles de paquetes" do
      f.input :description
      f.input :classes
      f.input :price
      f.input :special_price
      f.input :expiration
    end
    f.actions
  end

end
