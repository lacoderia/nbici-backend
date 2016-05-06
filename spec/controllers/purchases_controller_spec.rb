feature 'PurchasesController' do
  include ActiveJob::TestHelper

  let!(:user_01) { create(:user) }
  let!(:pack) { create(:pack) }
  let!(:card) { create(:card, user: user_01) }

  context 'Create a new purchase' do

    it 'should purchase a pack' do
        
      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_purchase_request = {pack_id: pack.id, price: pack.price, uid: card.uid}      
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["purchase"]["user"]["id"]).to be user_01.id
      expect(SendEmailJob).to have_been_enqueued.with("purchase", global_id(user_01), global_id(Purchase.last))
        
      perform_enqueued_jobs { SendEmailJob.perform_later("purchase", user_01, Purchase.last) } 

      #Refresh de user
      user = User.find(user_01.id)
      expect(user.classes_left).to eql 1

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
      new_purchase_request = {pack_id: 3, price: pack.price, uid: card.uid}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Couldn't find Pack with 'id'=3"

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
      expect(response["errors"][0]["title"]).to eql "Phone missing in details."

    end
    
  end

end
