ActiveAdmin.register Purchase, :as => "Compras" do

  actions :all, :except => [:show, :destroy, :update, :edit]

  filter :user_last_name, :label => "Apellido de cliente", :as => :string
  filter :created_at, :label => "Fecha"
  filter :amount, :label => "Precio"
  filter :promotion, :label => "Promocion", :collection => Promotion.all.collect {|p| [p.coupon, p.id]}

  permit_params :description, :amount, user_attributes: [:id, :card_ids]

  FILTERS = ["user_last_name", "created_at", "amount", "promotion", "user_id"]

  config.sort_order = "created_at_desc"
  config.clear_action_items!  

  controller do
    def scoped_collection
      Purchase.with_users
    end

    def create

      begin

      # Make purchase
        if params[:purchase][:user_attributes] && params[:purchase][:user_attributes][:card_ids]

          user = User.find(params[:purchase][:user_attributes][:id])
          amount_initial = params[:purchase][:amount]
          amount_confirmation = params[:purchase][:amount_confirmation]
          currency = "MXN"
          description = params[:purchase][:description]
            
          card = Card.find(params[:purchase][:user_attributes][:card_ids])

          # render error        
          if (amount_initial != amount_confirmation) || (amount_initial.blank?) || (amount_initial.to_f < 3)
            flash[:error] = 'La cantidad no es válida'
            redirect_to "/admin/compras/new?user_id=#{params[:purchase][:user_attributes][:id]}" 
          
          elsif description.blank?
            flash[:error] = 'Se necesita una descripción'
            redirect_to "/admin/compras/new?user_id=#{params[:purchase][:user_attributes][:id]}" 
          else

            amount = (amount_initial.to_f * 100).to_i

            if not user.test?

              charge = Conekta::Charge.create({
                amount: amount,
                currency: currency,
                description: description,
                card: card.uid,
                details: {
                  name: card.name,
                  email: user.email,
                  phone: card.phone,
                  line_items: [{
                    name: description,
                    description: "Compra en recepcion",
                    unit_price: amount,
                    quantity: 1
                  }]
                }
              })

              purchase = Purchase.create!(
                user: user,
                pack: nil,
                uid: charge.id,
                object: charge.object, 
                livemode: charge.livemode, 
                status: charge.status,
                description: charge.description,
                amount: charge.amount,
                currency: charge.currency,
                payment_method: charge.payment_method,
                details: charge.details,
                promotion: nil
              ) 
      
            else

              purchase = Purchase.create!(
                user: user,
                pack: nil,
                uid: nil,
                object: nil, 
                livemode: nil, 
                status: nil,
                description: description,
                amount: amount,
                currency: currency,
                payment_method: nil,
                details: nil,
                promotion: nil
              )

            end        
          
            #NbiciMailer.send(:front_desk_purchase, user, purchase).deliver_now
            SendEmailJob.perform_later("front_desk_purchase", user, purchase)
        
            flash[:notice] = 'La compra se realizó correctamente.'
            redirect_to collection_url

          end

        # render error
        else
          
          flash[:error] = 'Información incompleta'
          redirect_to "/admin/compras/new?user_id=#{params[:purchase][:user_attributes][:id]}" 

        end

      rescue Exception => e

        if e.try(:message_to_purchaser)
          error = e.message_to_purchaser
        else
          error = e.message
        end
        
        flash[:error] = error
        redirect_to "/admin/compras/new?user_id=#{params[:purchase][:user_attributes][:id]}" 
        
      end      

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

    script do
      raw '$(function() { 
              $("form input[type=submit] ").on("click", function(){
              var con = confirm("¿Confirmar compra?");
              if (con == true) {
                return true;
              }
              else
                return false;           
              }); 
          });'
    end

    f.semantic_errors *f.object.errors.keys
    f.object.created_at = DateTime.now unless f.object.created_at

    f.inputs "Nueva compra" do

      if params[:user_id]
      
        f.object.user = User.find(params[:user_id])

        f.inputs "Detalles de usuario", for: [:user, f.object.user] do |u|

          if not f.object.user.cards.empty?
            primary_card = f.object.user.cards.where(primary: true).first
          else
            primary_card = nil
          end
        
          u.input :first_name, label: "Nombre", input_html: { disabled: true, style: "background-color: #d3d3d3;" }
          u.input :last_name, label: "Apellido", input_html: { disabled: true, style: "background-color: #d3d3d3;" }
          u.input :email, label: "Email", input_html: { disabled: true, style: "background-color: #d3d3d3;" }

          u.input :cards, label: "Tarjeta", collection: f.object.user.cards.map{|g| ["terminación-#{g.last4}", g.id]}, as: :radio,
            required: true, selected: primary_card.id if primary_card
          
        end
          
        para "<br/> <br/>".html_safe
                
        f.inputs "Detalles de compra" do

          f.input :description, label: "Descripción", required: true 
          f.input :amount, label: "Cantidad", required: true
          f.input :amount, label: "Confirmar cantidad", required: true,
            input_html: {id: "purchase_amount_confirmation", name: "purchase[amount_confirmation]"}
          
        end

      end

    end
    f.actions if params[:user_id]
    
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
