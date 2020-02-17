ActiveAdmin.register MenuItem, :as => "Productos" do

  menu parent: 'Dafit', priority: 0, if: proc {current_admin_user.role? :super_admin or current_admin_user.role? :dafit}

  actions :all, :except => [:show, :destroy]
  
  permit_params :name, :description, :price, :menu_category_id, :active

  config.filters = false  

  index :title => "Productos" do
    column "Nombre", :name
    column "Ingredientes", :description
    column "Precio", :price
    column "Activo?", :active
    column "Categoría" do |menu_item|
      menu_item.menu_category.name
    end
    actions :defaults => true    
  end

  form do |f|
    f.inputs "Detalles de producto" do
      f.input :name, label: "Nombre"
      f.input :description, label: "Ingredientes"
      f.input :price, label: "Precio"
      f.input :menu_category, label: "Categoría", :collection => MenuCategory.all.collect{|category| [category.name, category.id]}, as: :select, :include_blank => false
      f.input :active, label: "Activo?"
    end
    f.actions
  end

end
