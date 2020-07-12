require "test_helper"
require "application_system_test_case"

class CompaniesControllerTest < ApplicationSystemTestCase
  #have write two cases of email on update email value blank and on create email value should include @mgetmainstreet.com
  def setup
    @company = companies(:hometown_painting)
  end

  test "Index" do
    visit companies_path
    assert_text "Companies"
    assert_text "Hometown Painting"
    assert_text "Wolf Painting"
  end

  test "Show" do
    visit company_path(@company)
    assert_text @company.name
    assert_text @company.phone
    assert_text @company.email
    assert_text @company.city, @company.state
  end

  #allow company with email blank to update
  test "Update" do
    visit edit_company_path(@company)
    within("form#edit_company_#{@company.id}") do
      fill_in("company_name", with: "Updated Test Company")
      fill_in("company_zip_code", with: "93009")
      fill_in("company_email", with: "")
      click_button "Update Company"
    end
    assert_text "Changes Saved"
    @company.reload
    assert_equal "", @company.email
    assert_equal "Ventura", @company.city
    assert_equal "CA", @company.state
    assert_equal "Updated Test Company", @company.name
    assert_equal "93009", @company.zip_code
  end

  #allow company with email include @getmainstreet.com
  test "Create" do
    visit new_company_path
    within("form#new_company") do
      fill_in("company_name", with: "New Test Company")
      fill_in("company_zip_code", with: "28173")
      fill_in("company_phone", with: "5553335555")
      fill_in("company_email", with: "new_test_company@getmainstreet.com")
      click_button "Create Company"
    end
    assert_text "Saved"
    last_company = Company.last
    assert_equal "Waxhaw", last_company.city
    assert_equal "NC", last_company.state
    assert_equal "New Test Company", last_company.name
    assert_equal "28173", last_company.zip_code
  end

  #delete test case
  test "Delete" do
    visit companies_path
    company_count = Company.count
    within("#company_#{@company.id}") do
      click_link 'Delete'
    end
    page.driver.browser.switch_to.alert.accept #accept alert
    assert_text "Deleted"
    assert_equal Company.count, (company_count - 1)
    visit companies_path
  end
end
