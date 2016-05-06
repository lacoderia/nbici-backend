ActiveAdmin.register Instructor, :as => "Instructores" do

  actions :all, :except => [:show]

  permit_params :first_name, :last_name, :picture, :quote, :bio, admin_user_attributes: [:email, :password, :password_confirmation, :role_ids]

  config.filters = false

  index :title => "Instructores" do
    column "Nombre", :first_name	
    column "Apellido", :last_name
    column "Email" do |instructor|
      instructor.admin_user.email
    end
    column "Foto", :picture
    column "Cita", :quote
    column "Bio", :bio
    actions :defaults => true
  end

  form do |f|
    f.inputs "Detalles de cuenta" do
      f.has_many :admin_user, heading: 'Correo electrónico', allow_destroy: false, new_record: 'Agrega email y password' do |t|
        instructor_role = Role.find_by_name(:instructor)
        t.input :email
        t.input :password
        t.input :password_confirmation
        t.input :role_ids, as: :hidden, input_html: { value: instructor_role.id }
      end
    end
    f.inputs "Detalles de instructor" do
      f.input :first_name, label: "Nombre"
      f.input :last_name, label: "Apellido"
      f.input :picture, label: "Foto"
      f.input :quote, label: "Cita"
      f.input :bio, label: "Bio"
    f.actions
    end
  end

end
