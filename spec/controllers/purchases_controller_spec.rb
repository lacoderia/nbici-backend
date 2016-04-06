feature 'PurchasesController' do

  let!(:user_01) { create(:user) }
  let!(:pack) { create(:pack) }
  let!(:card) { create(:card, user: user_01) }

  context 'Create a new purchase' do

    it 'should purchase a pack' do
        
      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_purchase_request = {pack_id: pack.id, price: pack.price, token: card.uid}      
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["purchase"]["user_id"]).to be user_01.id

      #Refresh de user
      user = User.find(user_01.id)
      expect(user.classes_left).to eql 1

    end
    
    it 'validates purchase errors' do

      # Non logged user
      new_purchase_request = {pack_id: pack.id, price: pack.price, token: card.uid}
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
      new_purchase_request = {pack_id: pack.id, price: pack.price, token: "123456782342"}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["id"]).to eql "non_normal_operation_flow"
      
      # Incorrect pack
      new_purchase_request = {pack_id: 3, price: pack.price, token: card.uid}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["id"]).to eql "error_creating_purchase"

      # Incorrect price
      new_purchase_request = {pack_id: pack.id, price: "200.00", token: card.uid}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El precio enviado es diferente al precio del paquete."

      # Incorrect user params
      u = User.find(user_01.id)
      u.update_attribute(:phone, "22")
      new_purchase_request = {pack_id: pack.id, price: pack.price, token: card.uid}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["id"]).to eql "error_validating_parameters"

    end
    
  end

end
