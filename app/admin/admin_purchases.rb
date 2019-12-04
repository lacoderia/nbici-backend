ActiveAdmin.register Purchase, :as => "Compras" do

  actions :all, :except => [:show, :destroy, :update, :edit]

  filter :user_last_name, :label => "Apellido de cliente", :as => :string
  filter :created_at, :label => "Fecha"
  filter :amount, :label => "Precio"
  filter :promotion, :label => "Promocion", :collection => Promotion.all.collect {|p| [p.coupon, p.id]}

  FILTERS = ["user_last_name", "created_at", "amount", "promotion", "user_id"]

  config.sort_order = "created_at_desc"

  controller do
    def scoped_collection
      Purchase.with_users
    end
    
    def destroy
      super do |success,failure|
        redirect_path = admin_compras_path
        
        counter = 1
        params.each do |k, v|

          FILTERS.each do |filter|

            if k.include? filter
              if counter == 1 
                redirect_path += "?utf8=%E2%9C%93&q%5B#{k}=#{v}"
              else
                redirect_path += "&#{k}=#{v}"
              end
              counter += 1
            end
          end
        end
        success.html { redirect_to redirect_path }
      end
    end

  end


  form do |f|

    f.semantic_errors *f.object.errors.keys
    f.object.created_at = DateTime.now unless f.object.created_at

    f.inputs "Información de la compra" do

      if params[:user_id]
      
        f.object.user = User.find(params[:user_id])

        f.inputs "Detalles de usuario" do

          f.input :user_id, label: "email", as: :select, 
            collection: User.all.sort_by{|user| user.email}.map{|user| ["#{user.email} - #{user.first_name} #{user.last_name}", user.id]}, 
            include_blank: false

          if not f.object.user.cards.empty?
            primary_card = f.object.user.cards.where("primary = ?", true).first
          else
            primary_card = nil
          end

          f.input :user_cards, label: "Tarjeta", collection: f.object.cards.map{|g| [g.last4, g.id]}, 
            input_html: { onchange: "" }, selected: primary_card.id if primary_card

        end
        
        f.inputs "Detalles de compra" do

          f.input :description, label: "Descripción"
          f.input :amount, label: "Cantidad"
          f.input :amount, label: "Confirmar cantidad"
        end

      end

    end
    f.actions
    
  end

  index :title => "Compras" do
    column "Cliente" do |purchase|
      "#{purchase.user.first_name} #{purchase.user.last_name}"
    end

    column "Compra" do |purchase|
      if purchase.pack
        "#{purchase.pack.description}" 
      else
        "#{purchase.description}"
      end
    end

    column "Precio" do |purchase|
      purchase.amount / 100.0
    end

    column "Fecha", :created_at 

    actions defaults: false do |purchase|
      link_path = admin_compra_path(purchase.id)
      if params[:q]
        counter = 1
        params[:q].each do |k, v|
          if counter == 1
            link_path += "?#{k}=#{v}"
          else
            link_path += "&#{k}=#{v}"
          end
          counter += 1
        end
      end
        link_to "Delete", link_path, method: :delete, data: {:confirm => "Eliminarás esta compra. ¿Estás seguro?"}
    end

  end

  
end
