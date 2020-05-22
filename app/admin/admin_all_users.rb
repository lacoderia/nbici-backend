ActiveAdmin.register User, :as => "Todos_los_clientes" do

  menu parent: 'Usuarios', priority: 0    

  actions :all, :except => [:new, :show, :destroy]

  permit_params :classes_left, :streaming_classes_left, :last_class_purchased, :credits, :expiration_date, credit_modifications_attributes: [:user_id, :reason, :credits, :pack_id, :is_money, :is_streaming], purchases_attributes: [:user_id, :pack_id, :object, :livemode, :status, :description, :amount, :currency, :payment_method, :details]
  
  filter :first_name, :as => :string, :label => "Nombre"
  filter :last_name, :as => :string, :label => "Apellido"
  filter :email, :as => :string
  filter :linked, :label => "Ligada"
  filter :created_at, :label => "Fecha de creación"

  config.sort_order = 'created_at_desc'

  action_item only: :edit do
    if resource.is_a?(User) and resource.purchases.empty?
      link_to "Delete", admin_todos_los_cliente_path(resource.id), method: :delete, data: {:confirm => "Eliminarás al usuario. ¿Estás seguro?"}
    end
  end

  controller do
    def destroy
      super
    end

    def update
      if (not params[:user][:credit_modifications_attributes].first[1][:credits].blank?) and
        (params[:user][:credit_modifications_attributes].first[1][:credits] != 0)

        user = User.find(params[:id])

        if params[:user][:credit_modifications_attributes].first[1][:is_money] == "1"
          params[:user][:credits] = user.credits + (params[:user][:credit_modifications_attributes].first[1][:credits].to_f)
        elsif params[:user][:credit_modifications_attributes].first[1][:is_streaming] == "1" 
          params[:user][:streaming_classes_left] = user.streaming_classes_left + (params[:user][:credit_modifications_attributes].first[1][:credits].to_i)
        else
          params[:user][:classes_left] = params[:user][:classes_left].to_i + (params[:user][:credit_modifications_attributes].first[1][:credits].to_i)
        end
        
        if not params[:user][:credit_modifications_attributes].first[1][:pack_id].blank?
          
          pack = Pack.find(params[:user][:credit_modifications_attributes].first[1][:pack_id])
          if user.purchases.empty? and not pack.special_price.nil?
            amount = pack.special_price.to_i*100
          else
            amount = pack.price.to_i*100
          end

          purchase = {"1" => {"user_id" => user.id,
                              "pack_id" => pack.id, 
                              "object" => "charge", 
                              "livemode" => true, 
                              "status" => "paid",
                              "description" => pack.description,
                              "amount" => amount,
                              "currency" => "MXN",
                              "payment_method" => "cash",
                              "details" => "pago en efecitvo"
          } }

          params[:user][:purchases_attributes] = purchase

          if user.expiration_date
            if user.expiration_date <= Time.zone.now
              expiration_date = Time.zone.now + pack.expiration.days
            else
              expiration_date = user.expiration_date + pack.expiration.days
            end
          else
            expiration_date = Time.zone.now + pack.expiration.days
          end
          
        elsif params[:user][:credit_modifications_attributes].first[1][:is_money] == "0"
          
          credits = params[:user][:credit_modifications_attributes].first[1][:credits].to_i
          less_or_equal_to_zero = ->(x) { x <= 0 }

          case credits
            when less_or_equal_to_zero
              expiration = 0
            when 1..4
              expiration = 15
            when 5..9
              expiration = 30
            when 10..24
              expiration = 90
            when 25..49
              expiration = 180
            else
              expiration = 360
            end
                
          if user.expiration_date and expiration > 0

            if user.expiration_date <= Time.zone.now
              expiration_date = Time.zone.now + expiration.days
            else
              expiration_date = user.expiration_date + expiration.days
            end

          elsif not user.expiration_date and expiration > 0
            expiration_date = Time.zone.now + expiration.days
          end

        end
        
        params[:user][:last_class_purchased] = Time.zone.now if expiration_date
        params[:user][:expiration_date] = expiration_date if expiration_date 
        #NbiciMailer.send(:credit_modifications, user, params[:user][:credit_modifications_attributes].values[0]).deliver_now
        SendEmailJob.perform_later("credit_modifications", user, params[:user][:credit_modifications_attributes].values[0])
      end
      super
    end
  end

  index :title => "Clientes" do
    column "Nombre", :first_name
    column "Apellido", :last_name
    column "Email", :email
    column "Clases restantes", :classes_left
    column "Streaming restantes", :streaming_classes_left
    column "Créditos", :credits
    column "Ligada", :linked
#    column "Fecha de creación", :created_at 

    actions defaults: false do |user|
      links = "#{link_to "View Credits", "#{admin_modificaciones_de_creditos_path}?q%5Buser_id_equals%5D=#{user.id}&commit=Filter&order=id_desc"} "
      links += "#{link_to "Edit Credits", "#{admin_todos_los_cliente_path(user.id)}/edit"} "
      links += "#{link_to "New Purchase", "#{new_admin_compras_paquete_path}?user_id=#{user.id}"} "
      if user.purchases.empty?
        links += "#{link_to "Delete", admin_todos_los_cliente_path(user.id), method: :delete, data: {:confirm => "Eliminarás al usuario. ¿Estás seguro?"} }"
      else
        links += (link_to "Purchase List", "#{admin_compras_paquetes_path}?q%5Buser_id_equals%5D=#{user.id}").to_s
      end
      links.html_safe
    end

  end

  form do |f|
    f.inputs "Modificación de créditos" do

      1.times do
        f.object.credit_modifications.build if f.object.errors.messages.empty? 
      end
      f.fields_for :credit_modifications do |t|
        if t.object.new_record?
          t.inputs do
            t.input :pack, label: "Purchased pack", :collection => Pack.active.face_to_face.collect {|pack| [pack.classes, pack.id]}, :as => :select, input_html: { id: "pack_id", onchange: "if(!this.value){ $('#credit_id')[0].readOnly=false; $('#credit_id')[0].style = 'background-color: #FFFFFF;'; $('#money_id')[0].disabled = false;  $('#streaming_id')[0].disabled = false; } else {$('#credit_id').val(this.options[this.selectedIndex].text); $('#credit_id')[0].readOnly=true; $('#credit_id')[0].style = 'background-color: #d3d3d3;'; $('#money_id')[0].checked = false; $('#money_id')[0].disabled = true; $('#streaming_id')[0].checked = false; $('#streaming_id')[0].disabled = true; }" }
            t.input :credits, :as => :number, input_html: {id: "credit_id"}
            t.input :is_money, label: "Money?", input_html: {id: "money_id", onchange: "if(this.checked){ $('#streaming_id')[0].disabled = true; $('#streaming_id')[0].checked = false;}else{ $('#streaming_id')[0].disabled = false; }" }
            t.input :is_streaming, label: "Streaming?", input_html: {id: "streaming_id", onchange: "if(this.checked){ $('#money_id')[0].disabled = true; $('#money_id')[0].checked = false;}else{ $('#money_id')[0].disabled = false; }"}
            t.input :reason, input_html: {id: "reason_id"}
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
