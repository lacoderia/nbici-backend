feature 'DiscountsController' do

  let!(:user_without_credits) { create(:user) }
  let!(:user_with_credits) { create(:user, credits: Configuration.referral_credit) }
  let!(:pack) { create(:pack) }
  let!(:pack_with_discount) { create(:pack, special_price: 100.00) }
  let!(:coupon_discount) { create(:configuration, :coupon_discount) }

  context 'Coupon discount methods' do

    it 'should validate errors for discount' do

      login_with_service user = { email: user_without_credits.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      validate_coupon_request = {pack_id: pack.id + 100, coupon: user_without_credits.coupon}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El paquete no existe."

      validate_coupon_request = {pack_id: pack.id, coupon: user_without_credits.coupon + "F"}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El cupón no existe."

      Referral.create!(owner: user_with_credits, referred: user_without_credits, credits: Configuration.referral_credit, used: false)

      validate_coupon_request = {pack_id: pack.id, coupon: user_without_credits.coupon}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "Ya has usado un cupón anteriormente."

    end

    it 'should validate prices for discount' do

      login_with_service user = { email: user_without_credits.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      validate_coupon_request = {pack_id: pack.id, coupon: user_without_credits.coupon}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["coupon"]).to eq user_without_credits.coupon
      expect(response["discount"]["final_price"]).to eq (pack.price - Configuration.coupon_discount)

      validate_coupon_request = {pack_id: pack_with_discount.id, coupon: user_without_credits.coupon}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["coupon"]).to eq user_without_credits.coupon
      expect(response["discount"]["final_price"]).to eq (pack_with_discount.special_price - Configuration.coupon_discount)

    end

  end

  context 'Credit discount methods' do

    it 'should validate errors for credits' do

      login_with_service user = { email: user_with_credits.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      validate_credit_request = {pack_id: pack.id + 100}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_credits_path, validate_credit_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El paquete no existe."

    end

    it 'should validate prices for credits' do

      login_with_service user = { email: user_with_credits.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      validate_credit_request = {pack_id: pack.id}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_credits_path, validate_credit_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["initial_price"]).to eql pack.price
      expect(response["discount"]["final_price"]).to eql pack.price - Configuration.referral_credit
      expect(response["discount"]["final_credits"]).to eql 0.0

      validate_credit_request = {pack_id: pack_with_discount.id}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_credits_path, validate_credit_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["initial_price"]).to eql pack_with_discount.special_price
      expect(response["discount"]["final_price"]).to eql pack_with_discount.special_price - Configuration.referral_credit
      expect(response["discount"]["final_credits"]).to eql 0.0

    end

  end
end
