require 'test_helper'

class EmailsControllerTest < ActionController::TestCase
  setup do
    @email = emails(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:emails)
  end

  test "should create email" do
    assert_difference('Email.count') do
      post :create, email: { status: @email.status, type: @email.type, user_id: @email.user_id }
    end

    assert_response 201
  end

  test "should show email" do
    get :show, id: @email
    assert_response :success
  end

  test "should update email" do
    put :update, id: @email, email: { status: @email.status, type: @email.type, user_id: @email.user_id }
    assert_response 204
  end

  test "should destroy email" do
    assert_difference('Email.count', -1) do
      delete :destroy, id: @email
    end

    assert_response 204
  end
end
