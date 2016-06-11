ActiveAdmin.register User, :as => "Todos_los_clientes" do

  actions :all, :except => [:new, :show, :destroy]

  permit_params :classes_left, :last_class_purchased, credit_modifications_attributes: [:user_id, :reason, :credits, :pack_id], purchases_attributes: [:user_id, :pack_id, :object, :livemode, :status, :description, :amount, :currency, :payment_method, :details]
  
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
        if not params[:user][:credit_modifications_attributes].first[1][:pack_id].blank?
          user = User.find(params[:id])
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
          params[:user][:last_class_purchased] = Time.zone.now
        end
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
            t.input :pack, :collection => Pack.all, :as => :select, :member_label => Proc.new { |r| "#{r.classes}" }, input_html: { onchange: "if(!this.value){ $('#credit_id')[0].readOnly=false; $('#credit_id')[0].style = 'background-color: #FFFFFF;'} else {$('#credit_id').val(this.options[this.selectedIndex].text); $('#credit_id')[0].readOnly=true; $('#credit_id')[0].style = 'background-color: #d3d3d3;'}" }
            t.input :credits, :as => :number, input_html: {id: "credit_id"}
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
