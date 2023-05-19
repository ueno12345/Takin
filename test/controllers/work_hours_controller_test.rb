require "test_helper"

class WorkHoursControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work_hour = work_hours(:one)
  end

  test "should get index" do
    get work_hours_url
    assert_response :success
  end

  test "should get new" do
    get new_work_hour_url
    assert_response :success
  end

  test "should create work_hour" do
    assert_difference("WorkHour.count") do
      post work_hours_url, params: { work_hour: { actual_working_minutes: @work_hour.actual_working_minutes, assignment_id: @work_hour.assignment_id, dtend: @work_hour.dtend, dtstart: @work_hour.dtstart } }
    end

    assert_redirected_to work_hour_url(WorkHour.last)
  end

  test "should show work_hour" do
    get work_hour_url(@work_hour)
    assert_response :success
  end

  test "should get edit" do
    get edit_work_hour_url(@work_hour)
    assert_response :success
  end

  test "should update work_hour" do
    patch work_hour_url(@work_hour), params: { work_hour: { actual_working_minutes: @work_hour.actual_working_minutes, assignment_id: @work_hour.assignment_id, dtend: @work_hour.dtend, dtstart: @work_hour.dtstart } }
    assert_redirected_to work_hour_url(@work_hour)
  end

  test "should destroy work_hour" do
    assert_difference("WorkHour.count", -1) do
      delete work_hour_url(@work_hour)
    end

    assert_redirected_to work_hours_url
  end
end
