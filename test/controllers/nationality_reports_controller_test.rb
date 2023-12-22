require "test_helper"

class NationalityReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @nationality_report = nationality_reports(:one)
  end

  test "should get index" do
    get nationality_reports_url
    assert_response :success
  end

  test "should get new" do
    get new_nationality_report_url
    assert_response :success
  end

  test "should create nationality_report" do
    assert_difference("NationalityReport.count") do
      post nationality_reports_url, params: { nationality_report: { result: @nationality_report.result } }
    end

    assert_redirected_to nationality_report_url(NationalityReport.last)
  end

  test "should show nationality_report" do
    get nationality_report_url(@nationality_report)
    assert_response :success
  end

  test "should get edit" do
    get edit_nationality_report_url(@nationality_report)
    assert_response :success
  end

  test "should update nationality_report" do
    patch nationality_report_url(@nationality_report), params: { nationality_report: { result: @nationality_report.result } }
    assert_redirected_to nationality_report_url(@nationality_report)
  end

  test "should destroy nationality_report" do
    assert_difference("NationalityReport.count", -1) do
      delete nationality_report_url(@nationality_report)
    end

    assert_redirected_to nationality_reports_url
  end
end
