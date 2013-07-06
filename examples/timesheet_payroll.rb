require 'rubygems'
require 'pp'
require 'yaml'

require File.dirname(__FILE__) + '/../lib/xero_gateway.rb'

XERO_KEYS = YAML.load_file(File.dirname(__FILE__) + '/xero_keys.yml')

gateway = XeroGateway::Gateway.new(XERO_KEYS["xero_consumer_key"], XERO_KEYS["xero_consumer_secret"])

# authorize in browser specific to payroll-API
%x(google-chrome #{gateway.request_token.authorize_url}"&scope=payroll.employees,payroll.payitems, payroll.leaveapplications, payroll.timesheets")

puts "Enter the verification code from Xero?"
oauth_verifier = gets.chomp

gateway.authorize_from_request(gateway.request_token.token, gateway.request_token.secret, :oauth_verifier => oauth_verifier)

# Get first employee
puts "========= employees"
employees = gateway.get_payroll_employees.response_item
pp employees.inspect

# Get timesheets
puts "========= get timesheets"
timesheets = gateway.get_payroll_timesheets.response_item
pp timesheets.inspect

puts "============ get timesheet by employee_id"
timesheet = gateway.get_payroll_timesheet_by_employee_id(employees[1].employee_id)
pp timesheet.inspect
