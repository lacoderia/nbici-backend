ActiveAdmin.register Waitlist, :as => "Waitlist" do

  menu parent: 'Operacion Interna', priority: 5 

  actions :all, :except => [:destroy, :show, :edit, :update]

  filter :user_email, :as => :string, :label => "Email"
  filter :schedule, :label => "Clase reciente", :collection => Schedule.recent.collect{|s| [s.datetime.strftime("%d/%m/%Y %I:%M%p"), s.id]}
  filter :schedule_datetime, :label => "Clase por fecha", :as => :date_time_range

  permit_params :schedule_id, user_attributes: [:id]

  config.sort_order = "created_at_desc"
  config.clear_action_items!

  controller do
    
    def create

      begin
        
        # Create waitlist
        if params[:waitlist][:user_attributes] && params[:waitlist][:user_attributes][:id]

          user = User.find(params[:waitlist][:user_attributes][:id])
          schedule = Schedule.find(params[:waitlist][:schedule_id])

          #validatios
          #available seats
          if schedule.available_seats > 0
            raise "La clase todavía tiene asientos disponibles."
          end

          #already in waitlist 
          #if not schedule.waitlists.where(user: user).empty?
          #  raise "Usuario ya está registrado en la lista de espera."
          #end
          
          #time 
          if Time.zone.now >= (schedule.datetime - 12.hours)
            raise "Sólo se puede ingresar a lista de espera con al menos 12 horas de anticipación."
          end

          #credits
          if user.credits < schedule.price
            raise "El usuario no tiene suficientes créditos para entrar a la lista de espera."
          end

          user.update_attribute(:credits, user.credits - schedule.price)
          waitlist = Waitlist.create!(schedule: schedule, user: user, status: "WAITING")
          SendEmailJob.perform_later("waitlist", user, waitlist)
          
          flash[:notice] = 'El ingreso a la lista de espera se realizó correctamente.'
          redirect_to collection_url
        end

      rescue Exception => e

        error = e.message
                
        flash[:error] = error
        redirect_to "#{new_admin_waitlist_path}?user_id=#{params[:waitlist][:user_attributes][:id]}" 
        
      end      

    end

  end

  index do
    column 'Usuario' do |waitlist|
      waitlist.user.email
    end
    column 'Clase' do |waitlist|
      waitlist.schedule.datetime
    end
    column "Status" do |waitlist|
      Waitlist::STATUSES.find{|status| status[1] == waitlist.status}[0]
    end
  end

  form do |f|

    f.semantic_errors *f.object.errors.keys

  	if params[:user_id]
      
      f.object.user = User.find(params[:user_id])

      f.inputs "Detalles de usuario", for: [:user, f.object.user] do |u|
        
        u.input :first_name, label: "Nombre", input_html: { disabled: true, style: "background-color: #d3d3d3;" }
        u.input :last_name, label: "Apellido", input_html: { disabled: true, style: "background-color: #d3d3d3;" }
        u.input :email, label: "Email", input_html: { disabled: true, style: "background-color: #d3d3d3;" }
        u.input :credits, label: "Creditos", input_html: { disabled: true, style: "background-color: #d3d3d3;" }
      end

    	f.inputs "Clases especiales próximas" do
      	f.input :schedule, label: "Fecha y hora", :collection => Schedule.incoming.special.collect{|schedule| [schedule.datetime, schedule.id]}
      	f.actions
    	end
    end
  end

end
