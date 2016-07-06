ActiveAdmin.register Purchase, :as => "Control_de_ingresos" do
  
  actions :all, :except => [:show, :new, :destroy, :update]
  
  filter :created_at, :label => "Fecha"

  config.sort_order = "created_at_desc"
  
  scope("Hace 3 meses"){|scope| scope.where("purchases.created_at >= ? and purchases.created_at <= ?", Time.zone.now.beginning_of_month - 3.month, Time.zone.now.end_of_month - 3.month)}
  
  scope("Hace 2 meses"){|scope| scope.where("purchases.created_at >= ? and purchases.created_at <= ?", Time.zone.now.beginning_of_month - 2.month, Time.zone.now.end_of_month - 2.month)}
  
  scope("Hace 1 mes"){|scope| scope.where("purchases.created_at >= ? and purchases.created_at <= ?", Time.zone.now.beginning_of_month - 1.month, Time.zone.now.end_of_month - 1.month)}
  
  scope("Mes actual"){|scope| scope.where("purchases.created_at >= ? and purchases.created_at <= ?", Time.zone.now.beginning_of_month, Time.zone.now.end_of_month)}
  
  controller do
    def scoped_collection
      Purchase.with_users_and_appointments_and_bom_and_eom
    end
  end

  index :title => "Control de ingresos" do
  
    column "Cliente" do |purchase|
      "#{purchase.user.first_name} #{purchase.user.last_name}"
    end

    column "Paquete" do |purchase|
      "#{purchase.pack.description}"
    end

    column "Precio" do |purchase|
      purchase.amount / 100.0
    end

    column "Fecha", :created_at

    column "Usadas" do |purchase|
      appointments_in_month = purchase.user.appointments.where("start BETWEEN ? and ?", purchase.bom, purchase.eom)
      appointments_in_month.count
    end

    column "Disponible" do |purchase|
      appointments_in_month = purchase.user.appointments.where("start BETWEEN ? and ?", purchase.bom, purchase.eom)
      price_per_class = (purchase.amount / 100.0) / purchase.pack.classes
      if appointments_in_month.count <= purchase.pack.classes
        appointments_in_month.count * price_per_class
      else
        0.0
      end
    end
  end

  csv do

    column "Cliente" do |purchase|
      "#{purchase.user.first_name} #{purchase.user.last_name}"
    end

    column "Paquete" do |purchase|
      "#{purchase.pack.description}"
    end

    column "Precio" do |purchase|
      purchase.amount / 100.0
    end

    column "Fecha" do |purchase|
      purchase.created_at
    end

    column "Usadas" do |purchase|
      appointments_in_month = purchase.user.appointments.where("start BETWEEN ? and ?", purchase.bom, purchase.eom)
      appointments_in_month.count
    end

    column "Disponible" do |purchase|
      appointments_in_month = purchase.user.appointments.where("start BETWEEN ? and ?", purchase.bom, purchase.eom)
      price_per_class = (purchase.amount / 100.0) / purchase.pack.classes
      if appointments_in_month.count <= purchase.pack.classes
        appointments_in_month.count * price_per_class
      else
        (purchase.amount / 100.0)
      end
    end
    
  end
  
end
