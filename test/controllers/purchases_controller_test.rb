require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  setup do
    @purchase = purchases(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:purchases)
  end

  test "should create purchase" do
    assert_difference('Purchase.count') do
      post :create, purchase: { amount: @purchase.amount, currency: @purchase.currency, description: @purchase.description, details: @purchase.details, livemode: @purchase.livemode, object: @purchase.object, pack_id: @purchase.pack_id, payment_method: @purchase.payment_method, status: @purchase.status, uid: @purchase.uid, user_id: @purchase.user_id }
    end

    assert_response 201
  end

  test "should show purchase" do
    get :show, id: @purchase
    assert_response :success
  end

  test "should update purchase" do
    put :update, id: @purchase, purchase: { amount: @purchase.amount, currency: @purchase.currency, description: @purchase.description, details: @purchase.details, livemode: @purchase.livemode, object: @purchase.object, pack_id: @purchase.pack_id, payment_method: @purchase.payment_method, status: @purchase.status, uid: @purchase.uid, user_id: @purchase.user_id }
    assert_response 204
  end

  test "should destroy purchase" do
    assert_difference('Purchase.count', -1) do
      delete :destroy, id: @purchase
    end

    assert_response 204
  end
end
