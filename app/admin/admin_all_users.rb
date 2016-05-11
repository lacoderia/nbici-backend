ActiveAdmin.register User, :as => "Todos_los_clientes" do

  actions :all, :except => [:new, :show, :destroy]

  permit_params :classes_left, credit_modifications_attributes: [:user_id, :reason, :credits]
  
  filter :last_name, :as => :string
  filter :first_name, :as => :string
  filter :email, :as => :string
  filter :classes_left

  config.sort_order = 'created_at_desc'

  controller do
    def update
      if (not params[:user][:credit_modifications_attributes].first[1][:credits].blank?) and
        (params[:user][:credit_modifications_attributes].first[1][:credits] != 0)
        params[:user][:classes_left] = params[:user][:classes_left].to_i + (params[:user][:credit_modifications_attributes].first[1][:credits].to_i)
      end
      super
    end
  end

  index :title => "Clientes" do
    column "Nombre", :first_name
    column "Apellido", :last_name
    column "Email", :email
    column "Clases restantes", :classes_left
    actions :defaults => true
  end

  form do |f|
    f.inputs "Modificación de créditos" do
  
      1.times do
        f.object.credit_modifications.build
      end
      f.fields_for :credit_modifications do |t|
        if t.object.new_record?
          t.inputs do
            t.input :credits, :as => :number
            t.input :reason
          end
        end
      end

      f.input :classes_left, as: :hidden, input_html: {value: f.object.classes_left}
      f.actions    
    end
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
