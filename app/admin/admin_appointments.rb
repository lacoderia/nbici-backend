ActiveAdmin.register User, :as => "Resumen_clases_por_usuario" do

  actions :all, :except => [:show, :new, :destroy, :update, :edit]

  filter :first_name, :label => "Nombre"
  filter :last_name, :label => "Apellido"

  controller do
    def scoped_collection
      User.with_appointments_summary
    end
  end

  index :title => "Clientes" do
    column "Nombre", :first_name
    column "Apellido", :last_name
    column "Clases restantes", :classes_left
    column "Reservadas", :sortable => 'users["booked"]' do |user|
      user["booked"]
    end
    column "Canceladas", :sortable => 'users["cancelled"]' do |user|
      user["cancelled"]
    end
    column "Finalizadas", :sortable => 'users["finalized"]' do |user|
      user["finalized"]
    end
  end

end
