ActiveAdmin.register Purchase, :as => "Compras" do

  actions :all, :except => [:show, :new, :destroy, :update, :edit]

  filter :user_last_name, :label => "Apellido de cliente", :as => :string
  filter :created_at, :label => "Fecha"
  filter :amount, :label => "Precio"

  config.sort_order = "created_at_desc"

  controller do
    def scoped_collection
      Purchase.with_users_and_appointments
    end
  end

  index :title => "Compras" do
    column "Cliente" do |purchase|
      "#{purchase.user.first_name} #{purchase.user.last_name}"
    end

    column "Paquete" do |purchase|
      "#{purchase.pack.description}"
    end

    column "Precio", :amount

    column "Fecha", :created_at 

  end

  
end
