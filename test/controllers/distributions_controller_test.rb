require 'test_helper'

class DistributionsControllerTest < ActionController::TestCase
  setup do
    @distribution = distributions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:distributions)
  end

  test "should create distribution" do
    assert_difference('Distribution.count') do
      post :create, distribution: { active_sits: @distribution.active_sits, description: @distribution.description, height: @distribution.height, inactive_sits: @distribution.inactive_sits, total_sits: @distribution.total_sits, width: @distribution.width }
    end

    assert_response 201
  end

  test "should show distribution" do
    get :show, id: @distribution
    assert_response :success
  end

  test "should update distribution" do
    put :update, id: @distribution, distribution: { active_sits: @distribution.active_sits, description: @distribution.description, height: @distribution.height, inactive_sits: @distribution.inactive_sits, total_sits: @distribution.total_sits, width: @distribution.width }
    assert_response 204
  end

  test "should destroy distribution" do
    assert_difference('Distribution.count', -1) do
      delete :destroy, id: @distribution
    end

    assert_response 204
  end
end
