require 'test_helper'

class PacksControllerTest < ActionController::TestCase
  setup do
    @pack = packs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:packs)
  end

  test "should create pack" do
    assert_difference('Pack.count') do
      post :create, pack: { amount: @pack.amount, classes: @pack.classes, description: @pack.description }
    end

    assert_response 201
  end

  test "should show pack" do
    get :show, id: @pack
    assert_response :success
  end

  test "should update pack" do
    put :update, id: @pack, pack: { amount: @pack.amount, classes: @pack.classes, description: @pack.description }
    assert_response 204
  end

  test "should destroy pack" do
    assert_difference('Pack.count', -1) do
      delete :destroy, id: @pack
    end

    assert_response 204
  end
end
