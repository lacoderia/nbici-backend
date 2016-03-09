require 'test_helper'

class InstructorsControllerTest < ActionController::TestCase
  setup do
    @instructor = instructors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:instructors)
  end

  test "should create instructor" do
    assert_difference('Instructor.count') do
      post :create, instructor: { email: @instructor.email, first_name: @instructor.first_name, last_name: @instructor.last_name, picture: @instructor.picture }
    end

    assert_response 201
  end

  test "should show instructor" do
    get :show, id: @instructor
    assert_response :success
  end

  test "should update instructor" do
    put :update, id: @instructor, instructor: { email: @instructor.email, first_name: @instructor.first_name, last_name: @instructor.last_name, picture: @instructor.picture }
    assert_response 204
  end

  test "should destroy instructor" do
    assert_difference('Instructor.count', -1) do
      delete :destroy, id: @instructor
    end

    assert_response 204
  end
end
