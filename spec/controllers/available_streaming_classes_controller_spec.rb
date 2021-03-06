feature 'AvailableStreamingClassesController' do
  include ActiveJob::TestHelper

  let!(:starting_datetime){Time.zone.parse('01 Jan 2016 00:00:00')}
  let!(:user_with_streaming_classes){create(:user, streaming_classes_left: 2, classes_left: 1)}
  let!(:user_with_no_streaming_classes){create(:user, classes_left: 0)}
  

  #Streaming classes
  let!(:streaming_class_01){create(:streaming_class)}
  let!(:streaming_class_02){create(:streaming_class)}
  let!(:streaming_class_03){create(:streaming_class)}
  let!(:streaming_class_04){create(:streaming_class, featured: true)}
  let!(:streaming_class_05){create(:streaming_class)}
  let!(:streaming_class_06){create(:streaming_class)}
  let!(:streaming_class_07){create(:streaming_class, :inactive)}

  context 'Querying streaming classes' do

    it 'should get all active streaming classes' do

      visit streaming_classes_path
      response = JSON.parse(page.body)
      expect(response["streaming_classes"].size).to eql 6      

    end

  end

  context 'Purchasing a streaming class' do

    before do
      Timecop.freeze(starting_datetime)
    end

    it 'Should purchase a streaming class' do

      #Login
      page = login_with_service user = { email: user_with_streaming_classes[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      #querying logged in
      visit streaming_classes_path
      response = JSON.parse(page.body)
      expect(response["streaming_classes"].size).to eql 6
      
      #buying first class with streaming credits
      streaming_class_purchase = {streaming_class_id: streaming_class_01.id}
      with_rack_test_driver do
        page.driver.post purchase_available_streaming_classes_path, streaming_class_purchase
      end
      response = JSON.parse(page.body)
      expect(response["available_streaming_class"]["user"]["id"]).to eql user_with_streaming_classes.id
      expect(response["available_streaming_class"]["streaming_class"]["id"]).to eql streaming_class_01.id
      expect(response["available_streaming_class"]["start"]).to eql starting_datetime.strftime("%FT%T.%L%:z")
      user_with_streaming_classes.reload
      expect(user_with_streaming_classes.streaming_classes_left).to eql 1
      expect(user_with_streaming_classes.classes_left).to eql 1

      expect(SendEmailJob).to have_been_enqueued.with("streaming_booking", global_id(user_with_streaming_classes), global_id(AvailableStreamingClass.last))
      perform_enqueued_jobs { SendEmailJob.perform_later("streaming_booking", user_with_streaming_classes, AvailableStreamingClass.last) } 

      #buying second class with streaming credits
      Timecop.freeze(starting_datetime + 1.hour)
      streaming_class_purchase = {streaming_class_id: streaming_class_02.id}
      with_rack_test_driver do
        page.driver.post purchase_available_streaming_classes_path, streaming_class_purchase
      end      
      response = JSON.parse(page.body)
      expect(response["available_streaming_class"]["start"]).to eql (starting_datetime + 1.hour).strftime("%FT%T.%L%:z")      
      user_with_streaming_classes.reload
      expect(user_with_streaming_classes.streaming_classes_left).to eql 0
      expect(user_with_streaming_classes.classes_left).to eql 1
      
      expect(SendEmailJob).to have_been_enqueued.with("streaming_booking", global_id(user_with_streaming_classes), global_id(AvailableStreamingClass.last))
      perform_enqueued_jobs { SendEmailJob.perform_later("streaming_booking", user_with_streaming_classes, AvailableStreamingClass.last) } 

      #querying available streaming classes
      visit available_streaming_classes_path
      response = JSON.parse(page.body)
      expect(response["available_streaming_classes"].size).to eql 2
      expect(response["available_streaming_classes"][0]["user"]["id"]).to eql user_with_streaming_classes.id
      expect(response["available_streaming_classes"][0]["streaming_class"]["id"]).to eql streaming_class_01.id
      expect(response["available_streaming_classes"][1]["streaming_class"]["id"]).to eql streaming_class_02.id
      
      Timecop.travel(starting_datetime + 24.hours)

      #querying available streaming classes
      visit available_streaming_classes_path
      response = JSON.parse(page.body)
      expect(response["available_streaming_classes"].size).to eql 1      
      expect(response["available_streaming_classes"][0]["insertion_code"]).to be nil
      
      #querying available streaming class show for first class
      visit streaming_class_path(streaming_class_01.id)
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "La clase ya cumplió su periodo de 24 horas de disponibilidad desde que la compraste."

      #querying available streaming class show for second class
      visit streaming_class_path(streaming_class_02.id)
      response = JSON.parse(page.body)
      expect(response["streaming_class"]["insertion_code"]).not_to be nil
      expect(response["streaming_class"]["instructor"]["active"]).to be true
      expect(response["available_streaming_class"]["streaming_class_id"]).to eql streaming_class_02.id

      Timecop.travel(starting_datetime + 25.hours)

      #querying available streaming classes
      visit available_streaming_classes_path
      response = JSON.parse(page.body)
      expect(response["available_streaming_classes"].size).to eql 0

      #buying third class with regular credits
      Timecop.freeze(starting_datetime + 26.hour)
      streaming_class_purchase = {streaming_class_id: streaming_class_01.id}
      with_rack_test_driver do
        page.driver.post purchase_available_streaming_classes_path, streaming_class_purchase
      end      
      response = JSON.parse(page.body)
      expect(response["available_streaming_class"]["start"]).to eql (starting_datetime + 26.hour).strftime("%FT%T.%L%:z")      
      user_with_streaming_classes.reload
      expect(user_with_streaming_classes.streaming_classes_left).to eql 0
      expect(user_with_streaming_classes.classes_left).to eql 0
      
      expect(SendEmailJob).to have_been_enqueued.with("streaming_booking", global_id(user_with_streaming_classes), global_id(AvailableStreamingClass.last))
      perform_enqueued_jobs { SendEmailJob.perform_later("streaming_booking", user_with_streaming_classes, AvailableStreamingClass.last) } 
    
      expect(Email.count).to eql 3

      #querying available streaming class show for last class
      visit streaming_class_path(streaming_class_01.id)
      response = JSON.parse(page.body)
      expect(response["streaming_class"]["insertion_code"]).not_to be nil
      expect(response["streaming_class"]["instructor"]["active"]).to be true
      expect(response["available_streaming_class"]["streaming_class_id"]).to eql streaming_class_01.id

      logout

      #Login
      page = login_with_service user = { email: user_with_no_streaming_classes[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      #querying available streaming class show for first class
      visit streaming_class_path(streaming_class_01.id)
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "La clase no está disponible para este usuario."    

    end

    it 'Should test the errors for purchasing a streaming class' do

      # Non logged user
      streaming_class_purchase = {streaming_class_id: streaming_class_01.id}
      with_rack_test_driver do
        page.driver.post purchase_available_streaming_classes_path, streaming_class_purchase
      end
      response = JSON.parse(page.body)
      expect(page.status_code).to be 401

      #Login
      page = login_with_service user = { email: user_with_no_streaming_classes[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      #Non existent class
      streaming_class_purchase = {streaming_class_id: (streaming_class_07.id + 10)}
      with_rack_test_driver do
        page.driver.post purchase_available_streaming_classes_path, streaming_class_purchase
      end
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "Couldn't find StreamingClass with 'id'=#{(streaming_class_07.id + 10)}"

      #Non available class
      streaming_class_purchase = {streaming_class_id: streaming_class_07.id}
      with_rack_test_driver do
        page.driver.post purchase_available_streaming_classes_path, streaming_class_purchase
      end
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "Clase no disponible."

      #Non available class
      streaming_class_purchase = {streaming_class_id: streaming_class_06.id}
      with_rack_test_driver do
        page.driver.post purchase_available_streaming_classes_path, streaming_class_purchase
      end
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "Ya no tienes clases disponibles, adquiere más para continuar."

      user_with_no_streaming_classes.update_attribute("streaming_classes_left", 2)

      #purchasing one streaming class
      streaming_class_purchase = {streaming_class_id: streaming_class_06.id}
      with_rack_test_driver do
        page.driver.post purchase_available_streaming_classes_path, streaming_class_purchase
      end
      response = JSON.parse(page.body)
      expect(response["available_streaming_class"]["user"]["id"]).to eql user_with_no_streaming_classes.id

      #purchasing same streaming class
      streaming_class_purchase = {streaming_class_id: streaming_class_06.id}
      with_rack_test_driver do
        page.driver.post purchase_available_streaming_classes_path, streaming_class_purchase
      end
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "No necesitas comprar esa clase, ya la tienes disponible."

    end

  end


end
