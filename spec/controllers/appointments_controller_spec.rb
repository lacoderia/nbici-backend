feature 'AppointmentsController' do

  let!(:schedule) { create(:schedule) }
  let!(:user_with_classes_left) { create(:user, classes_left: 2, last_class_purchased: Time.zone.now) }
  let!(:user_with_no_classes_left) { create(:user, classes_left: 0, last_class_purchased: Time.zone.now) }
  let!(:user_with_nil_classes_left) { create(:user) }

  context 'Create a new appointment' do

    it 'should create successfully an appointment and error on creating one with the same bicycle or with another user_id' do
        
      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"]).to eq "[4]"
      user = User.find(user_with_classes_left.id)
      expect(user.classes_left).to be 1 

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi otra clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "La bicicleta 4 ya fue seleccionada para la schedule #{schedule.id}."

    end

    it 'checks for errors on users with no classes left' do
      #USER WITH NO SESSION
      with_rack_test_driver do
        page.driver.post book_appointments_path, {} 
      end
      expect(page.status_code).to be 401

      #USER WITH NO CLASSES LEFT
      page = login_with_service user = { email: user_with_no_classes_left[:email], password: "12345678" }
      new_appointment_request_no_classes = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request_no_classes
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El usuario no cuenta con suficientes clases disponibles."
      logout

      #RECENTLY CREATED USER WITH NO CLASSES LEFT DEFINED
      page = login_with_service user = { email: user_with_nil_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1
      new_appointment_request_nil_classes = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request_nil_classes
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El usuario no cuenta con suficientes clases disponibles."
      logout

      #INACTIVE SEAT TRYING TO BE BOOKED
      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1
      schedule.room.distribution.update_attribute(:inactive_seats, "[4]")

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "La bicicleta 4 está inactiva para la schedule #{schedule.id}."

    end
    
  end

end
