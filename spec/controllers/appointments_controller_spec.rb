feature 'AppointmentsController' do

  let!(:schedule) { create(:schedule) }
  let!(:user_with_classes_left) { create(:user, classes_left: 2, last_class_purchased: Time.zone.now) }
  let!(:user_with_no_classes_left) { create(:user, classes_left: 0, last_class_purchased: Time.zone.now) }
  let!(:user_with_nil_classes_left) { create(:user) }

  context 'Create a new appointment' do

    it 'should create successfully an appointment and error on creating one with the same bicycle' do

      new_appointment_request = {user_id: user_with_classes_left.id, schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      
      response = JSON.parse(page.body)
      expect(response["appointment"]["booked_seats"]).to eq "[4]"
      user = User.find(user_with_classes_left.id)
      expect(user.classes_left).to be 1 

      new_appointment_request = {user_id: user_with_classes_left.id, schedule_id: schedule.id, bicycle_number: 4, description: "Mi otra clase"}      
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["id"]).to eql "bicycle_already_booked"

    end

    it 'checks for errors on users with no classes left' do

      #USER WITH NO CLASSES LEFT
      new_appointment_request_no_classes = {user_id: user_with_no_classes_left.id, schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request_no_classes
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["id"]).to eql "no_classes_left"

      #RECENTLY CREATED USER WITH NO CLASSES LEFT DEFINED
      new_appointment_request_nil_classes = {user_id: user_with_nil_classes_left.id, schedule_id: schedule.id, bicycle_number: 4, description: "Mi primera clase"}
      with_rack_test_driver do
        page.driver.post book_appointments_path, new_appointment_request_nil_classes
      end
      response = JSON.parse(page.body)
      expect(response["errors"][0]["id"]).to eql "no_classes_left"

    end
    
  end

end
