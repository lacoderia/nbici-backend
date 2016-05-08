ActiveAdmin.register PaymentSummary, :as => "Pago_a_instructores" do

  actions :all, :except => [:show, :new, :edit, :update, :delete]

  controller do
    def scoped_collection
      PaymentSummary.create_array(Schedule.for_payments)
    end
  end

  index :title => "Resumen" do
    binding.pry
    
    #column "Instructor" do |schedule|
    #end
    #column "Asistentes" do |schedule| 
    #end
    
  end
end
