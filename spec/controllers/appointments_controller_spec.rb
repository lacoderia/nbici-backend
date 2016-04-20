feature 'AppointmentsController' do

  let!(:starting_datetime) { Time.zone.parse('01 Jan 2016 00:00:00') }  
  
  let!(:schedule) { create(:schedule, datetime: starting_datetime + 1.hour) }
  let!(:user_with_classes_left) { create(:user, classes_left: 2, last_class_purchased: starting_datetime) }
  let!(:user_with_no_classes_left) { create(:user, classes_left: 0, last_class_purchased: starting_datetime) }
  let!(:user_with_nil_classes_left) { create(:user) }

  context 'Create new appointments' do

    before do
      Timecop.freeze(starting_datetime)
    end

    it 'should expire appointments' do

      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"][0]["number"]).to eq 4
      appointment = Appointment.find(response["appointment"]["id"])
      expect(appointment.status).to eql "BOOKED"

      Timecop.travel(starting_datetime + 2.hours)
      Appointment.finalize
      
      appointment = Appointment.find(response["appointment"]["id"])
      expect(appointment.status).to eql "FINALIZED"
      
      #Can't book past schedules
      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 2, description: "Mi otra clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "La clase ya está fuera de horario."
      
    end

    it 'should create successfully an appointment and error on creating one with the same bicycle or with another user_id' do
      
      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"][0]["number"]).to eq 4
      user = User.find(user_with_classes_left.id)
      expect(user.classes_left).to be 1 
      expect(SendEmailJob).to have_been_enqueued.with("booking", global_id(user_with_classes_left), global_id(Appointment.last))

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 4, description: "Mi otra clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "La bicicleta ya fue reservada, por favor intenta con otra."

    end

    it 'checks for errors on users with no classes left' do
      Timecop.travel(starting_datetime)
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
      expect(response["errors"][0]["title"]).to eql "Ya no tienes clases disponibles, adquiere más para continuar."
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
      expect(response["errors"][0]["title"]).to eql "Ya no tienes clases disponibles, adquiere más para continuar."
      logout

      #UNEXISTANT SEAT TRYING TO BE BOOKED
      page = login_with_service user = { email: user_with_classes_left[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_appointment_request = {schedule_id: schedule.id, bicycle_number: 5, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Esa bicicleta no existe, por favor intenta nuevamente."

    end
    
  end

end
