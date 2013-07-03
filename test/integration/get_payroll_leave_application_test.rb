require File.dirname(__FILE__) + '/../test_helper'

class GetPayrollLeaveApplicationTest < Test::Unit::TestCase
  include TestHelper

  def setup
    @gateway = XeroGateway::Gateway.new(CONSUMER_KEY, CONSUMER_SECRET)

    if STUB_XERO_CALLS
      @gateway.xero_payroll_url = "DUMMY_URL"
      @gateway.stubs(:http_get).with {|client, url, params| url =~ /LeaveApplications\/[^\/]+$/ }.returns(get_file_as_string("payroll_leave_application.xml"))
    end
  end

  def test_payroll_get_leave_application
    employee_id = "9157d509-4d61-46f1-bb6c-f3c68c308a48"    
    result = @gateway.get_payroll_leave_application_by_id(employee_id)
    assert !result.request_params.nil?
    assert !result.response_xml.nil?

    assert_equal result.response_item.leave_type_id, "07ca6967-03f6-4c04-9a99-999b1e424e86"
    assert_equal result.response_item.leave_application_id, "aa40b7e8-b964-43d9-9ebe-0ba81583cea3"
    assert_equal result.response_item.employee_id, "9157d509-4d61-46f1-bb6c-f3c68c308a48"
    assert_equal result.response_item.title, "My single leave_application"
  end
end
