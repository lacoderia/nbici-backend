ActiveAdmin.register MenuPurchase, :as => "Menu Compras" do

  menu parent: 'Dafit', priority: 1

  actions :all, :except => [:show, :new, :destroy, :update, :edit]

  config.sort_order = "created_at_desc"  
  
  filter :status, :label => "Status", as: :select, :collection => MenuPurchase::STATUSES
  filter :schedule, :label => "Clase", :collection => Schedule.recent.collect{|s| [s.datetime.strftime("%d/%m/%Y %I:%M%p"), s.id]}
  #filter :appointment, :label => "Clase", :collection => Appointment.all.collect {|a| [a.start.strftime("%d/%m/%Y %I:%M%p"), a.id]}

  index :title => "Compras" do

    column "Cliente" do |menu_purchase|
      "#{menu_purchase.user.first_name} #{menu_purchase.user.last_name}"        
    end
    column "Productos" do |menu_purchase|
      menu_purchase.get_items_description 
    end
    column "Notas", :notes
    column "Precio" do |menu_purchase|
      menu_purchase.amount / 100.0
    end
    column "Clase" do |menu_purchase|
      menu_purchase.appointment.start.strftime("%d/%m/%Y %I:%M%p")
    end
    column "Status", :status
    
  end

end
