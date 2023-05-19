require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
  end

  test "visiting the index" do
    visit courses_url
    assert_selector "h1", text: "Courses"
  end

  test "should create course" do
    visit courses_url
    click_on "New course"

    fill_in "Description", with: @course.description
    fill_in "Instructor", with: @course.instructor
    fill_in "Name", with: @course.name
    fill_in "Number", with: @course.number
    fill_in "Term", with: @course.term
    fill_in "Time budget", with: @course.time_budget
    fill_in "Year", with: @course.year
    click_on "Create Course"

    assert_text "Course was successfully created"
    click_on "Back"
  end

  test "should update Course" do
    visit course_url(@course)
    click_on "Edit this course", match: :first

    fill_in "Description", with: @course.description
    fill_in "Instructor", with: @course.instructor
    fill_in "Name", with: @course.name
    fill_in "Number", with: @course.number
    fill_in "Term", with: @course.term
    fill_in "Time budget", with: @course.time_budget
    fill_in "Year", with: @course.year
    click_on "Update Course"

    assert_text "Course was successfully updated"
    click_on "Back"
  end

  test "should destroy Course" do
    visit course_url(@course)
    click_on "Destroy this course", match: :first

    assert_text "Course was successfully destroyed"
  end
end
