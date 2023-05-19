require "test_helper"

class TeachingAssistantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @teaching_assistant = teaching_assistants(:one)
  end

  test "should get index" do
    get teaching_assistants_url
    assert_response :success
  end

  test "should get new" do
    get new_teaching_assistant_url
    assert_response :success
  end

  test "should create teaching_assistant" do
    assert_difference("TeachingAssistant.count") do
      post teaching_assistants_url, params: { teaching_assistant: { description: @teaching_assistant.description, grade: @teaching_assistant.grade, labo: @teaching_assistant.labo, name: @teaching_assistant.name, number: @teaching_assistant.number, year: @teaching_assistant.year } }
    end

    assert_redirected_to teaching_assistant_url(TeachingAssistant.last)
  end

  test "should show teaching_assistant" do
    get teaching_assistant_url(@teaching_assistant)
    assert_response :success
  end

  test "should get edit" do
    get edit_teaching_assistant_url(@teaching_assistant)
    assert_response :success
  end

  test "should update teaching_assistant" do
    patch teaching_assistant_url(@teaching_assistant), params: { teaching_assistant: { description: @teaching_assistant.description, grade: @teaching_assistant.grade, labo: @teaching_assistant.labo, name: @teaching_assistant.name, number: @teaching_assistant.number, year: @teaching_assistant.year } }
    assert_redirected_to teaching_assistant_url(@teaching_assistant)
  end

  test "should destroy teaching_assistant" do
    assert_difference("TeachingAssistant.count", -1) do
      delete teaching_assistant_url(@teaching_assistant)
    end

    assert_redirected_to teaching_assistants_url
  end
end
