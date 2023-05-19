require "application_system_test_case"

class TeachingAssistantsTest < ApplicationSystemTestCase
  setup do
    @teaching_assistant = teaching_assistants(:one)
  end

  test "visiting the index" do
    visit teaching_assistants_url
    assert_selector "h1", text: "Teaching assistants"
  end

  test "should create teaching assistant" do
    visit teaching_assistants_url
    click_on "New teaching assistant"

    fill_in "Description", with: @teaching_assistant.description
    fill_in "Grade", with: @teaching_assistant.grade
    fill_in "Labo", with: @teaching_assistant.labo
    fill_in "Name", with: @teaching_assistant.name
    fill_in "Number", with: @teaching_assistant.number
    fill_in "Year", with: @teaching_assistant.year
    click_on "Create Teaching assistant"

    assert_text "Teaching assistant was successfully created"
    click_on "Back"
  end

  test "should update Teaching assistant" do
    visit teaching_assistant_url(@teaching_assistant)
    click_on "Edit this teaching assistant", match: :first

    fill_in "Description", with: @teaching_assistant.description
    fill_in "Grade", with: @teaching_assistant.grade
    fill_in "Labo", with: @teaching_assistant.labo
    fill_in "Name", with: @teaching_assistant.name
    fill_in "Number", with: @teaching_assistant.number
    fill_in "Year", with: @teaching_assistant.year
    click_on "Update Teaching assistant"

    assert_text "Teaching assistant was successfully updated"
    click_on "Back"
  end

  test "should destroy Teaching assistant" do
    visit teaching_assistant_url(@teaching_assistant)
    click_on "Destroy this teaching assistant", match: :first

    assert_text "Teaching assistant was successfully destroyed"
  end
end
