feature 'MenuPurchasesController' do
  include ActiveJob::TestHelper

  let!(:starting_datetime){Time.zone.parse('01 Jan 2016 00:00:00')}  

  let!(:user_01){create(:user)}
  let!(:user_02){create(:user)}
  let!(:user_03){create(:user)}
  let!(:user_04){create(:user)}
  let!(:user_05){create(:user)}
  let!(:user_staff){create(:user, credits: 100.0)}
  let!(:card){create(:card, user: user_01)}
  let!(:card_02){create(:card, :master_card, user: user_02)}
  let!(:card_03){create(:card, :visa_card_2, user: user_03)}
  let!(:card_04){create(:card, :master_card_2, user: user_04)}
  let!(:card_05){create(:card, :amex, user: user_05)}
  let!(:card_no_funds){create(:card, :no_funds, user: user_01)}

  #Schedules  
  let!(:future_sch_01){create(:schedule, datetime: starting_datetime + 1.hour, description: "futuro uno")}
  
  #Appointments
  let!(:future_app_01){create(:appointment, user: user_01, schedule: future_sch_01, start: future_sch_01.datetime, bicycle_number: 1)}
  let!(:future_app_02){create(:appointment, user: user_02, schedule: future_sch_01, start: future_sch_01.datetime, bicycle_number: 2)}
  let!(:future_app_03){create(:appointment, user: user_03, schedule: future_sch_01, start: future_sch_01.datetime, bicycle_number: 3)}
  let!(:future_app_04){create(:appointment, user: user_04, schedule: future_sch_01, start: future_sch_01.datetime, bicycle_number: 4)}
  let!(:future_app_05){create(:appointment, user: user_05, schedule: future_sch_01, start: future_sch_01.datetime, bicycle_number: 5)}
  let!(:future_app_06){create(:appointment, user: user_staff, schedule: future_sch_01, start: future_sch_01.datetime, bicycle_number: 6)}

  #Menu Items
  let!(:menu_item_01){create(:menu_item)}
  let!(:menu_item_02){create(:menu_item)}
  let!(:menu_item_02){create(:menu_item, active: false)}

  context 'Create a new purchase' do

    it 'should purchase a menu item' do
        
      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      #Request categories with items
      visit menu_categories_path
      response = JSON.parse(page.body)

      expect(response["menu_categories"].count).to eql 2

      new_menu_purchase_request = {appointment_id: future_app_01.id, price: menu_item_01.price, uid: card.uid, notes: "Sin queso", 
      menu_items: [{id: menu_item_01.id, amount: 1}]}      
      
      expect(user_01.menu_purchases.count).to eql 0

      with_rack_test_driver do
        page.driver.post charge_menu_purchases_path, new_menu_purchase_request
      end
      
      response = JSON.parse(page.body)

      expect(response["menu_purchase"]["user"]["id"]).to be user_01.id
      expect(SendEmailJob).to have_been_enqueued.with("menu_purchase", global_id(user_01), global_id(MenuPurchase.last))
        
      perform_enqueued_jobs { SendEmailJob.perform_later("purchase", user_01, MenuPurchase.last) } 

      #Reload user
      user_01.reload
      expect(user_01.menu_purchases.count).to eql 1

    end
    
    it 'validates purchase errors' do

      # Non logged user
      new_purchase_request = {pack_id: pack.id, price: pack.price, uid: card.uid}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(page.status_code).to be 401

      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      # Incorrect requests
      # Incorrect token
      new_purchase_request = {pack_id: pack.id, price: pack.price, uid: "123456782342"}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Tarjeta no encontrada o registrada."
      
      # Incorrect pack
      new_purchase_request = {pack_id: 900, price: pack.price, uid: card.uid}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Couldn't find Pack with 'id'=900"

      # Incorrect price
      new_purchase_request = {pack_id: pack.id, price: "200.00", uid: card.uid}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El precio enviado es diferente al precio del paquete."

      # Incorrect user params
      c = Card.find(card.id)
      c.update_attribute(:phone, "22")
      new_purchase_request = {pack_id: pack.id, price: pack.price, uid: card.uid}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Falta el teléfono en el campo \"details\"."

      #No funds
      new_purchase_request = {pack_id: pack.id, price: pack.price, uid: card_no_funds.uid}      
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body) 
      expect(response["errors"][0]["title"]).to eql "Esta tarjeta no tiene suficientes fondos para completar la compra."

      #COUPON
      #Incorrect price
      new_purchase_request = {pack_id: pack.id, price: pack.price, uid: card.uid, coupon: user_02.coupon.upcase}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El precio enviado es diferente al precio con descuento."

    end
    
  end

end

