feature 'DiscountsController' do

  let!(:user_01) { create(:user) }
  let!(:pack) { create(:pack) }
  let!(:pack_with_discount) { create(:pack, special_price: 100.00) }
  let!(:coupon_discount) { create(:configuration, :coupon_discount) }

  context 'Coupon discount methods' do

    it 'should validate errors for discount' do

      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      validate_coupon_request = {pack_id: pack.id + 100, coupon: user_01.coupon}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El paquete no existe."

      validate_coupon_request = {pack_id: pack.id, coupon: user_01.coupon + "F"}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["errors"][0]["title"]).to eql "El cupón no existe."

    end

    it 'should validate prices for discount' do

      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      validate_coupon_request = {pack_id: pack.id, coupon: user_01.coupon}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["coupon"]).to eq user_01.coupon
      expect(response["discount"]["final_price"]).to eq (pack.price - Configuration.coupon_discount)

      validate_coupon_request = {pack_id: pack_with_discount.id, coupon: user_01.coupon}      
      with_rack_test_driver do
        page.driver.post discounts_validate_with_coupon_path, validate_coupon_request
      end
      
      response = JSON.parse(page.body)
      expect(response["discount"]["coupon"]).to eq user_01.coupon
      expect(response["discount"]["final_price"]).to eq (pack_with_discount.special_price - Configuration.coupon_discount)

    end

  end

end
