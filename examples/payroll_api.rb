require 'rubygems'
require 'pp'
require 'yaml'

require File.dirname(__FILE__) + '/../lib/xero_gateway.rb'

XERO_KEYS = YAML.load_file(File.dirname(__FILE__) + '/xero_keys.yml')

gateway = XeroGateway::Gateway.new(XERO_KEYS["xero_consumer_key"], XERO_KEYS["xero_consumer_secret"])

# authorize in browser specific to payroll-API
%x(open #{gateway.request_token.authorize_url}"&scope=payroll.employees")

puts "Enter the verification code from Xero?"
oauth_verifier = gets.chomp  

gateway.authorize_from_request(gateway.request_token.token, gateway.request_token.secret, :oauth_verifier => oauth_verifier)

# Example payroll-API Call
a = gateway.get_payroll_employees.employees
pp a
b =  gateway.get_payroll_employee_by_id(a.first.employee_id)
pp b.employee
pp b.employee.home_address.region