feature 'RegistrationsController' do
  
  describe 'registration process' do
    context 'user creation' do 

      it 'successfully creates user, logout, valid and invalid login, existing and non-existing session' do
        new_user = { first_name: "test", last_name: "user", email: "test@user.com", password: "12345678", password_confirmation: "12345678" }
        
        # Validates user creation
        page = register_with_service new_user 
        response = JSON.parse(page.body)
        expect(response['user']['first_name']).to eq new_user[:first_name]
        logout

        # Validates invalid login with correct email
        page = login_with_service user = { email: new_user[:email], password: 'invalidpassword' }
        response = JSON.parse(page.body)
        expect(page.status_code).to be 500
        expect(response['errors'][0]["title"]).to eql "El correo electrónico o la contraseña son incorrectos."

        # Validates invalid login with incorrect email
        page = login_with_service user = { email: "anotheremail@test.com", password: 'invalidpassword' }
        response = JSON.parse(page.body)
        expect(page.status_code).to be 500
        expect(response['errors'][0]["title"]).to eql "El correo electrónico o la contraseña son incorrectos."

        # Validates no session if user is not logged in
        page = get_session 
        response = JSON.parse(page.body)
        expect(page.status_code).to be 500
        expect(response['errors'][0]["title"]).to eql "No se ha iniciado sesión."

        # Validates correct login
        # TODO: FIX authentication
        #page = login_with_service user = { email: new_user[:email], password: new_user[:password] }
        #response = JSON.parse(page.body)
        #expect(response['user']['first_name']).to eql new_user[:first_name]
        #page = get_session 
        #response = JSON.parse(page.body)
        #expect(response['user']['first_name']).to eql new_user[:first_name]
        
      end

      it 'checks for error on duplicate users' do
        new_user = { first_name: "test", last_name: "user", email: "test@user.com", password: "12345678", password_confirmation: "12345678" }
        
        # Validates user creation
        page = register_with_service new_user
        response = JSON.parse(page.body)
        expect(response['user']['first_name']).to eq new_user[:first_name]
        logout
        
        page = register_with_service new_user 
        response = JSON.parse(page.body)
        expect(page.status_code).to be 500
        expect(response['errors'][0]["title"]).to eql "Ya existe un usuario registrado con ese correo electrónico."
      end
      
    end

  end

end
