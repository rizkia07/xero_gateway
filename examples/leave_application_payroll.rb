require 'rubygems'
require 'pp'
require 'yaml'

require File.dirname(__FILE__) + '/../lib/xero_gateway.rb'

XERO_KEYS = YAML.load_file(File.dirname(__FILE__) + '/xero_keys.yml')

gateway = XeroGateway::Gateway.new(XERO_KEYS["xero_consumer_key"], XERO_KEYS["xero_consumer_secret"])

# authorize in browser specific to payroll-API
%x(google-chrome #{gateway.request_token.authorize_url}"&scope=payroll.employees,payroll.payitems, payroll.leaveapplications")

puts "Enter the verification code from Xero?"
oauth_verifier = gets.chomp

gateway.authorize_from_request(gateway.request_token.token, gateway.request_token.secret, :oauth_verifier => oauth_verifier)

# Example payitems-API calls
pay_items = gateway.get_pay_items.response_item

pp pay_items.inspect

# LEAVE_TYPES
leave_types = pay_items.leave_types
pp leave_types

# Get first employee
employees = gateway.get_payroll_employees.response_item

# Get LeaveApplications
leave_applications = gateway.get_payroll_leave_applications.response_item
pp leave_applications.inspect

#Create New LeaveApplication
new_leave_application = XeroGateway::Payroll::LeaveApplication.new
new_leave_application.gateway = gateway
new_leave_application.leave_type_id = leave_types.first.leave_type_id
new_leave_application.employee_id = employees[1].employee_id
new_leave_application.title = "My leave_application"
new_leave_application.start_date = Date.today
new_leave_application.end_date = Date.today + 1.week
new_leave_application.description = "My Description"
new_leave_application.leave_periods = [
  XeroGateway::Payroll::LeavePeriod.new(
    :number_of_units => 3,
    :pay_period_end_date => Date.today + 1.month,
    :pay_period_start_date => Date.today,
    :leave_period_status => "SCHEDULED"
  )  
]

#pp new_leave_application.to_xml
#response = new_leave_application.create 
#pp response.inspect


