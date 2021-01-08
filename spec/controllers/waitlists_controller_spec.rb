feature 'AppointmentsController' do
  include ActiveJob::TestHelper

  let!(:starting_datetime){Time.zone.parse('01 Jan 2016 00:00:00')}

  context 'Waitlist create actions' do

    let!(:schedule) { create(:schedule, datetime: starting_datetime + 13.hours) }
    let!(:special_schedule) { create(:schedule, datetime: starting_datetime + 14.hours, price: 150) }

    let!(:user) { create(:user, classes_left: 4, last_class_purchased: starting_datetime) }
    let!(:card){create(:card, user: user)}
    let!(:user_with_classes){create(:user, classes_left: 2, last_class_purchased: starting_datetime)}
    let!(:user_with_no_classes){create(:user, classes_left: 0, last_class_purchased: starting_datetime)}

    let!(:future_app_01){create(:appointment, user: user, schedule: schedule, start: schedule.datetime, bicycle_number: 1)}
    let!(:future_app_02){create(:appointment, user: user, schedule: schedule, start: schedule.datetime, bicycle_number: 2)}
    let!(:future_app_03){create(:appointment, user: user, schedule: schedule, start: schedule.datetime, bicycle_number: 3)}
    let!(:future_app_04){create(:appointment, user: user, schedule: schedule, start: schedule.datetime, bicycle_number: 4)}

    before do
      Timecop.freeze(starting_datetime)
    end

    it 'should join a waitlist in a regular class' do

      initial_credits = user_with_classes.classes_left

      #User with credits
      page = login_with_service user = { email: user_with_classes[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_waitlist_request = {schedule_id: schedule.id}
      with_rack_test_driver do
        page.driver.post waitlists_path, new_waitlist_request
      end

      response = JSON.parse(page.body)
      expect(response["waitlist"]["user_id"]).to eq user_with_classes.id
      expect(response["waitlist"]["status"]).to eql "WAITING"
      expect(response["waitlist"]["schedule"]["id"]).to eql schedule.id
      #Credits deducted
      expect(User.find(user_with_classes.id).classes_left).to eql (initial_credits - 1)

      new_waitlist_request = {schedule_id: schedule.id}
      with_rack_test_driver do
        page.driver.post waitlists_path, new_waitlist_request
      end
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "Ya estás registrado en la lista de espera."

    end

    it 'should join a waitlist in a special class with a price' do

      #User
      page = login_with_service user = { email: user[:email], password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_special_waitlist_request = {schedule_id: special_schedule.id, price: special_schedule.price, uid: card.uid}

      with_rack_test_driver do
        page.driver.post waitlists_path, new_special_waitlist_request
      end

      response = JSON.parse(page.body)
      expect(response["waitlist"]["user_id"]).to eq user.id
      expect(response["waitlist"]["status"]).to eql "WAITING"
      expect(response["waitlist"]["schedule"]["id"]).to eql special_schedule.id

      new_special_waitlist_request = {schedule_id: special_schedule.id, price: special_schedule.price, uid: card.uid}
      with_rack_test_driver do
        page.driver.post waitlists_path, new_special_waitlist_request
      end
      response = JSON.parse(page.body)
      expect(page.status_code).to be 500
      expect(response["errors"][0]["title"]).to eql "Ya estás registrado en la lista de espera."

    end

  end

end
