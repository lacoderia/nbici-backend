feature 'UsersController' do

  let!(:user_01){create(:user)}

  context 'user update' do

    it 'should update user' do

      login_with_service user = { email: user_01.email, password: "12345678" }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1

      update_user_request = {user:{first_name: "Arturo", password: 'ABCDEFG123', password_confirmation: 'ABCDEFG123'} }
      with_rack_test_driver do
        page.driver.put "#{users_path}/#{user_01.id}", update_user_request 
      end
      response = JSON.parse(page.body)
      expect(response['user']['first_name']).to eql "Arturo"

      page = get_session 
      response = JSON.parse(page.body)
      expect(response['user']['first_name']).to eql "Arturo"
      logout

      #Login with new password
      page = login_with_service updated_user = { email: user_01.email, password: 'ABCDEFG123' }
      access_token_1, uid_1, client_1, expiry_1, token_type_1 = get_headers
      set_headers access_token_1, uid_1, client_1, expiry_1, token_type_1
      
      response = JSON.parse(page.body)
      expect(response['user']['first_name']).to eql "Arturo"

      #Error, password doesn't match 
      update_user_request = {user:{password: 'ABCDEFG1234', password_confirmation: 'ABCDEFG12345'} }
      with_rack_test_driver do
        page.driver.put "#{users_path}/#{user_01.id}", update_user_request 
      end
      response = JSON.parse(page.body)
      expect(response['errors'][0]["title"]).to eql "doesn't match Password"
      
    end

  end

end
