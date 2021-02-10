ActiveAdmin.register Venue, :as => "Salone" do

  menu parent: 'Operacion Interna', priority: 6

  actions :all, :except => [:destroy, :new, :create, :show]

  permit_params :name
  
  config.filters = false
  config.clear_action_items!

  index do
    column 'Nombre' do |venue|
      venue.name
    end
    column 'Cuartos' do |venue|
      rooms = ""
      venue.rooms.each do |room|
        rooms += room.description + "<br>"
      end
      rooms.html_safe
    end
    actions :defaults => true
  end

  form do |f|

    f.semantic_errors *f.object.errors.keys

    f.inputs "Detalles del salón" do
      f.input :name, label: "Nombre"
      f.actions
    end
    
  end

end
