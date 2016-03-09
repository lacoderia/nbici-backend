require 'test_helper'

class AppointmentsControllerTest < ActionController::TestCase
  setup do
    @appointment = appointments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:appointments)
  end

  test "should create appointment" do
    assert_difference('Appointment.count') do
      post :create, appointment: { anomaly: @appointment.anomaly, bicycle_number: @appointment.bicycle_number, description: @appointment.description, schedule_id: @appointment.schedule_id, start: @appointment.start, status: @appointment.status, user_id: @appointment.user_id }
    end

    assert_response 201
  end

  test "should show appointment" do
    get :show, id: @appointment
    assert_response :success
  end

  test "should update appointment" do
    put :update, id: @appointment, appointment: { anomaly: @appointment.anomaly, bicycle_number: @appointment.bicycle_number, description: @appointment.description, schedule_id: @appointment.schedule_id, start: @appointment.start, status: @appointment.status, user_id: @appointment.user_id }
    assert_response 204
  end

  test "should destroy appointment" do
    assert_difference('Appointment.count', -1) do
      delete :destroy, id: @appointment
    end

    assert_response 204
  end
end
