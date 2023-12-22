require "application_system_test_case"

class NationalityReportsTest < ApplicationSystemTestCase
  setup do
    @nationality_report = nationality_reports(:one)
  end

  test "visiting the index" do
    visit nationality_reports_url
    assert_selector "h1", text: "Nationality reports"
  end

  test "should create nationality report" do
    visit nationality_reports_url
    click_on "New nationality report"

    fill_in "Result", with: @nationality_report.result
    click_on "Create Nationality report"

    assert_text "Nationality report was successfully created"
    click_on "Back"
  end

  test "should update Nationality report" do
    visit nationality_report_url(@nationality_report)
    click_on "Edit this nationality report", match: :first

    fill_in "Result", with: @nationality_report.result
    click_on "Update Nationality report"

    assert_text "Nationality report was successfully updated"
    click_on "Back"
  end

  test "should destroy Nationality report" do
    visit nationality_report_url(@nationality_report)
    click_on "Destroy this nationality report", match: :first

    assert_text "Nationality report was successfully destroyed"
  end
end
