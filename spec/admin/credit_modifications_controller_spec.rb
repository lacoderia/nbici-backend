feature 'CreditModificationsController' do
  
  let!(:starting_datetime) { Time.zone.parse('01 Jan 2016 00:00:00') }  
  
  let!(:admin_user) { create(:admin_user) }
  let!(:user) { create(:user) }
  let!(:pack) { create(:pack) }
  let!(:pack_50) { create(:pack, description: "50 pack", classes: 50, price: 5000.00, expiration: 360, special_price: 0) }

  context 'Manual modifications through the admin' do

    before do
      Timecop.freeze(starting_datetime)
    end
    
    it 'buys packs manually' do

      expect(user.expiration_date).to be nil
      expect(user.classes_left).to be nil
      expect(user.last_class_purchased).to be nil

      login_as_admin admin_user

      # Buy 1 pack
      visit(edit_admin_todos_los_cliente_path(user.id))
      select "1", :from => "pack_id"
      fill_in "credit_id", with: 1
      fill_in "reason_id", with: "Buying Pack Test"
      click_button 'Update User'

      user.reload
      expect(user.expiration_date).to eql starting_datetime + 15.days
      expect(user.classes_left).to be 1 
      expect(user.last_class_purchased).to eql starting_datetime
      expect(user.purchases.last.amount).to eql 10000

      # Buy another 1 pack
      visit(edit_admin_todos_los_cliente_path(user.id))
      select "1", :from => "pack_id"
      fill_in "credit_id", with: 1
      fill_in "reason_id", with: "Buying Pack Test 2"
      click_button 'Update User'

      user.reload
      expect(user.expiration_date).to eql starting_datetime + pack.expiration.days + pack.expiration.days
      expect(user.classes_left).to be 2 
      expect(user.last_class_purchased).to eql starting_datetime
      expect(user.purchases.last.amount).to eql 14000

      #ONE WEEK LATER
      one_week_after = starting_datetime + 8.days
      Timecop.travel(one_week_after)

      # Buy 50 pack
      visit(edit_admin_todos_los_cliente_path(user.id))
      select "50", :from => "pack_id"
      fill_in "credit_id", with: 50
      fill_in "reason_id", with: "Buying Pack Test 50"
      click_button 'Update User'

      user.reload
      expect(user.expiration_date).to eql starting_datetime + pack.expiration.days + pack.expiration.days + pack_50.expiration.days
      expect(user.classes_left).to be 52
      expect(user.last_class_purchased).to be_within(1.second).of one_week_after
      expect(user.purchases.last.amount).to eql 500000

      #TWO YEARS LATER
      two_years_later = one_week_after + 2.years
      Timecop.travel(two_years_later)

      User.expire_classes
      
      # Buy 1 pack
      visit(edit_admin_todos_los_cliente_path(user.id))
      select "1", :from => "pack_id"
      fill_in "credit_id", with: 1
      fill_in "reason_id", with: "Buying Pack Test Two Years Later"
      click_button 'Update User'

      user.reload
      expect(user.expiration_date).to be_within(1.second).of two_years_later + pack.expiration.days
      expect(user.classes_left).to be 1
      expect(user.last_class_purchased).to be_within(1.second).of two_years_later
      expect(user.purchases.last.amount).to eql 14000 

    end

    it 'adjusts credits manually' do

      expect(user.expiration_date).to be nil
      expect(user.classes_left).to be nil
      expect(user.last_class_purchased).to be nil

      login_as_admin admin_user
      
      # Added 4 credits
      visit(edit_admin_todos_los_cliente_path(user.id))
      fill_in "credit_id", with: 4
      fill_in "reason_id", with: "Added Manual Credits Test"
      click_button 'Update User'

      user.reload
      expect(user.expiration_date).to eql starting_datetime + 15.days
      expect(user.classes_left).to be 4 
      expect(user.last_class_purchased).to eql starting_datetime

      #ONE WEEK LATER
      one_week_after = starting_datetime + 8.days
      Timecop.travel(one_week_after)
      
      #Delete 2 credis
      visit(edit_admin_todos_los_cliente_path(user.id))
      fill_in "credit_id", with: -2
      fill_in "reason_id", with: "Added Manual Credits Test minus"
      click_button 'Update User'
      
      user.reload
      expect(user.expiration_date).to eql starting_datetime + 15.days
      expect(user.classes_left).to be 2
      expect(user.last_class_purchased).to eql starting_datetime

      #Add 5 more credits
      visit(edit_admin_todos_los_cliente_path(user.id))
      fill_in "credit_id", with: 5
      fill_in "reason_id", with: "Activeadmin Test"
      click_button 'Update User'

      user.reload
      expect(user.expiration_date).to eql starting_datetime + 15.days + 30.days
      expect(user.classes_left).to be 7
      expect(user.last_class_purchased).to be_within(1.second).of one_week_after

      #TWO YEARS LATER
      two_years_later = one_week_after + 2.years
      Timecop.travel(two_years_later)

      User.expire_classes
      
      # Add 4 more credits
      visit(edit_admin_todos_los_cliente_path(user.id))
      fill_in "credit_id", with: 4
      fill_in "reason_id", with: "Adding 4 classes Two Years Later"
      click_button 'Update User'

      user.reload
      expect(user.expiration_date).to be_within(1.second).of two_years_later + 15.days
      expect(user.classes_left).to be 4
      expect(user.last_class_purchased).to be_within(1.second).of two_years_later
      
    end

  end

end
