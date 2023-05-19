require "application_system_test_case"

class WorkHoursTest < ApplicationSystemTestCase
  setup do
    @work_hour = work_hours(:one)
  end

  test "visiting the index" do
    visit work_hours_url
    assert_selector "h1", text: "Work hours"
  end

  test "should create work hour" do
    visit work_hours_url
    click_on "New work hour"

    fill_in "Actual working minutes", with: @work_hour.actual_working_minutes
    fill_in "Assignment", with: @work_hour.assignment_id
    fill_in "Dtend", with: @work_hour.dtend
    fill_in "Dtstart", with: @work_hour.dtstart
    click_on "Create Work hour"

    assert_text "Work hour was successfully created"
    click_on "Back"
  end

  test "should update Work hour" do
    visit work_hour_url(@work_hour)
    click_on "Edit this work hour", match: :first

    fill_in "Actual working minutes", with: @work_hour.actual_working_minutes
    fill_in "Assignment", with: @work_hour.assignment_id
    fill_in "Dtend", with: @work_hour.dtend
    fill_in "Dtstart", with: @work_hour.dtstart
    click_on "Update Work hour"

    assert_text "Work hour was successfully updated"
    click_on "Back"
  end

  test "should destroy Work hour" do
    visit work_hour_url(@work_hour)
    click_on "Destroy this work hour", match: :first

    assert_text "Work hour was successfully destroyed"
  end
end
