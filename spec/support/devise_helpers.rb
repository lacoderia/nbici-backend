module TestingSupport
  module DeviseHelpers

    def login_with_service user
      with_rack_test_driver do
        page.driver.post user_session_path, { user: user}
      end
      return page
    end

    def register_with_service user
      with_rack_test_driver do
        page.driver.post user_registration_path, { user: user}
      end
      return page
    end

    def logout
      visit(logout_path)
    end

    def get_session
      visit(session_path)
      return page
    end

    #TODO: SETUP ADMIN 
    #def login_as_admin admin
    #  visit(new_premier_session_path)
    #  fill_in 'premier_email', with: admin.email
    #  fill_in 'premier_password', with: admin.password
    #  click_button 'Login'
    #end

    #def logout_as_admin
    #   visit(destroy_premier_session_path)
    #end

  end
end
