ActiveAdmin.register Promotion, :as => "Promociones" do

  actions :all, :except => [:show]

  permit_params :coupon, :description, :active, promotion_amounts_attributes: [:id, :amount, :pack_id, :promotion_id, :_destroy]
  
  config.filters = false

  index :title => "Promociones" do
    column "Cupón", :coupon
    column "Descripción", :description
    column "Activo", :active
    column "Uso" do |promotion|
      usage = {}
      promotion.purchases.each do |purchase|
        usage[purchase.pack_id] ? usage[purchase.pack_id] += 1 : usage[purchase.pack_id] = 1
      end

      details = ""
      usage.each do |k, v|
        details += "#{Pack.find(k).description} - #{v} veces <br>"
      end
      details.html_safe
    end
    actions :defaults => true
  end

  form do |f|
    f.inputs "Detalles de promociones" do
      f.input :coupon, label: "Cupón"
      f.input :description, label: "Descripción"
      f.input :active, label: "Activo"
      f.inputs "Cantidades por paquete" do
        f.has_many :promotion_amounts, allow_destroy: true, new_record: true do |a|
          a.input :amount, label: "Cantidad"
          a.input :pack, label: "Paquete", :collection => Pack.active.collect{|i| [ "#{i.description}", i.id]}, :as => :select 
        end
      end
    end
    f.actions
  end

end
