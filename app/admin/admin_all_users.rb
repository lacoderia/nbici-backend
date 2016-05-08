ActiveAdmin.register User, :as => "Todos_los_clientes" do

  actions :all, :except => [:new, :show, :update, :edit, :destroy]

  filter :last_name, :as => :string
  filter :first_name, :as => :string
  filter :email, :as => :string
  filter :classes_left

  config.sort_order = 'created_at_desc'

  index :title => "Clientes" do
    column "Nombre", :first_name
    column "Apellido", :last_name
    column "Email", :email
    column "Clases restantes", :classes_left
  end

  csv do
    column "Nombre" do |user|
      user.first_name
    end
    column "Apellido" do |user|
      user.last_name
    end
    column "Email" do |user|
      user.email
    end
  end

end
