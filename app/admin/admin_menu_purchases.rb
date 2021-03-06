ActiveAdmin.register MenuPurchase, :as => "Menu Compras" do

  menu parent: 'Dafit', priority: 1, if: proc {current_admin_user.role? :super_admin or current_admin_user.role? :dafit}

  actions :all, :except => [:show, :new, :destroy, :update, :edit]

  config.sort_order = "created_at_desc"  
  
  filter :status, :label => "Status", as: :select, :collection => MenuPurchase::STATUSES
  filter :schedule, :label => "Clase reciente", :collection => Schedule.recent.collect{|s| [s.datetime.strftime("%d/%m/%Y %I:%M%p"), s.id]}
  filter :schedule_datetime, :label => "Clase por fecha", :as => :date_time_range

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
