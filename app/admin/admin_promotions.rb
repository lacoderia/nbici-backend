ActiveAdmin.register Promotion, :as => "Promociones" do

  actions :all, :except => [:show]

  permit_params :coupon, :description, :active, promotion_amounts_attributes: [:id, :amount, :pack_id, :promotion_id, :_destroy]

  config.filters = false  
  
  controller do
    def scoped_collection
      Promotion.joins('LEFT OUTER JOIN purchases ON purchases.promotion_id = promotions.id').group("promotions.id")
    end
  end

  index :title => "Promociones" do
    column "Cupón", :coupon
    column "Descripción", :description
    column "Activo", :active
    column "Uso" do |promotion|
      link_to "#{promotion.purchases.count} compras", "#{admin_compras_path}?q%5Bpromotion_id_eq%5D=#{promotion.id}"
    end
    actions :defaults => true
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
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
