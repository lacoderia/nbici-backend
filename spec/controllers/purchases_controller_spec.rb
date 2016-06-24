feature 'PurchasesController' do
  include ActiveJob::TestHelper

  let!(:user_01){create(:user)}
  let!(:user_02){create(:user)}
  let!(:user_03){create(:user)}
  let!(:user_04){create(:user)}
  let!(:user_05){create(:user)}
  let!(:pack){create(:pack)}
  let!(:card){create(:card, user: user_01)}
  let!(:card_02){create(:card, :master_card, user: user_02)}
  let!(:card_03){create(:card, :visa_card_2, user: user_03)}
  let!(:card_04){create(:card, :master_card_2, user: user_04)}
  let!(:card_05){create(:card, :amex, user: user_05)}
  let!(:card_no_funds){create(:card, :no_funds, user: user_01)}
  let!(:promotion){create(:promotion)}

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

      #Reload user
      user_01.reload
      expect(user_01.classes_left).to eql 1
      expect(user_01.expiration_date).to be_within(1.second).of (user_01.last_class_purchased + pack.expiration.days)

    end

    it 'should stack credits from referrals' do

      expect(user_01.referrals.count).to eql 0

      login_with_service user = { email: user_02.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_purchase_request = {pack_id: pack.id, price: pack.price - Configuration.coupon_discount, uid: card_02.uid, coupon: user_01.coupon}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end

      logout

      login_with_service user = { email: user_03.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_purchase_request = {pack_id: pack.id, price: pack.price - Configuration.coupon_discount, uid: card_03.uid, coupon: user_01.coupon}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end

      logout

      login_with_service user = { email: user_04.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_purchase_request = {pack_id: pack.id, price: pack.price - Configuration.coupon_discount, uid: card_04.uid, coupon: user_01.coupon}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end

      logout

      login_with_service user = { email: user_05.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_purchase_request = {pack_id: pack.id, price: pack.price - Configuration.coupon_discount, uid: card_05.uid, coupon: user_01.coupon}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end

      logout

      #Purchase of user with +credits 
      user_01.reload
      initial_credits = user_01.credits
      expect(initial_credits).to eql (Configuration.referral_credit*4)

      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_purchase_request = {pack_id: pack.id, price: 0, uid: card.uid, credits: user_01.credits}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["purchase"]["user"]["id"]).to be user_01.id
      expect(SendEmailJob).to have_been_enqueued.with("purchase", global_id(user_01), global_id(Purchase.last))
        
      #Reload user
      user_01.reload
      expect(user_01.credits).to be > 0 
      expect(user_01.credits).to eql (initial_credits - pack.price)

    end

    it 'should purchase a pack with promotion discount' do

      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_purchase_request = {pack_id: pack.id, price: pack.price - promotion.amount, uid: card.uid, coupon: promotion.coupon}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["purchase"]["user"]["id"]).to be user_01.id
      expect(SendEmailJob).to have_been_enqueued.with("purchase", global_id(user_01), global_id(Purchase.last))
        
      perform_enqueued_jobs { SendEmailJob.perform_later("purchase", user_01, Purchase.last) } 

      #Reload user
      user_01.reload
      expect(user_01.classes_left).to eql 1
      expect(user_01.expiration_date).to be_within(1.second).of (user_01.last_class_purchased + pack.expiration.days)

    end

    it 'should purchase a pack with discount coupon and with credits' do
        
      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1
      
      expect(user_02.referrals.count).to eql 0

      new_purchase_request = {pack_id: pack.id, price: pack.price - Configuration.coupon_discount, uid: card.uid, coupon: user_02.coupon}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["purchase"]["user"]["id"]).to be user_01.id
      expect(SendEmailJob).to have_been_enqueued.with("purchase", global_id(user_01), global_id(Purchase.last))
        
      perform_enqueued_jobs { SendEmailJob.perform_later("purchase", user_01, Purchase.last) } 

      #Reload user
      user_01.reload
      user_02.reload
      expect(user_01.classes_left).to eql 1
      expect(user_01.expiration_date).to be_within(1.second).of (user_01.last_class_purchased + pack.expiration.days)
      expect(user_02.referrals.count).to eql 1
      expect(user_02.credits).to eql Configuration.referral_credit

      logout
      
      #Purchase of user with credits 
      login_with_service user = { email: user_02.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_purchase_request = {pack_id: pack.id, price: pack.price - Configuration.referral_credit, uid: card_02.uid, credits: user_02.credits}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["purchase"]["user"]["id"]).to be user_02.id
      expect(SendEmailJob).to have_been_enqueued.with("purchase", global_id(user_02), global_id(Purchase.last))
        
      perform_enqueued_jobs { SendEmailJob.perform_later("purchase", user_02, Purchase.last) } 

      #Reload user
      user_02.reload
      expect(user_02.classes_left).to eql 1
      expect(user_02.expiration_date).to be_within(1.second).of (user_02.last_class_purchased + pack.expiration.days)
      expect(user_02.credits).to eql 0.0

      logout

      #Should use a promotion coupon after a user's coupon without a problem
      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      new_purchase_request = {pack_id: pack.id, price: pack.price - promotion.amount, uid: card.uid, coupon: promotion.coupon}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["purchase"]["user"]["id"]).to be user_01.id
      expect(SendEmailJob).to have_been_enqueued.with("purchase", global_id(user_01), global_id(Purchase.last))
      
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
      expect(response["errors"][0]["title"]).to eql "Falta el teléfono en el campo 'details."

      #No funds
      new_purchase_request = {pack_id: pack.id, price: pack.price, uid: card_no_funds.uid}      
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body) 
      expect(response["errors"][0]["title"]).to eql "Esta tarjeta no tiene suficientes fondos para completar la compra."

      #COUPON
      #Incorrect price
      new_purchase_request = {pack_id: pack.id, price: pack.price, uid: card.uid, coupon: user_02.coupon}
      with_rack_test_driver do
        page.driver.post charge_purchases_path, new_purchase_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El precio enviado es diferente al precio con descuento."

    end
    
  end

end
