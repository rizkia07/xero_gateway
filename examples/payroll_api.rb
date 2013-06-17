require 'rubygems'
require 'pp'
require 'yaml'

require File.dirname(__FILE__) + '/../lib/xero_gateway.rb'

XERO_KEYS = YAML.load_file(File.dirname(__FILE__) + '/xero_keys.yml')

gateway = XeroGateway::Gateway.new(XERO_KEYS["xero_consumer_key"], XERO_KEYS["xero_consumer_secret"])

# authorize in browser specific to payroll-API
%x(google-chrome #{gateway.request_token.authorize_url}"&scope=payroll.employees")

puts "Enter the verification code from Xero?"
oauth_verifier = gets.chomp

gateway.authorize_from_request(gateway.request_token.token, gateway.request_token.secret, :oauth_verifier => oauth_verifier)

# Example payroll-API calls
#payroll_employees = gateway.get_payroll_employees.employees.map(&:employee_id)

#pp payroll_employees

# Retrieves Employee details and includes HomeAddress
#payroll_employee = gateway.get_payroll_employee_by_id(payroll_employees.first)
#pp payroll_employee.response_item
#pp payroll_employee.response_item.home_address.address_line1

employee = XeroGateway::Payroll::Employee.new 
#employee.first_name = "John6"
#employee.last_name = "John6"
employee.gateway  = gateway
employee.employee_id = "f4045df9-e1c7-493f-9d14-b7a013ed76b2"
#employee.date_of_birth = Date.today - 21.years
#employee.email = "test@payroll.com"
#employee.gender = "M"
#employee.middle_name = "Jono"
#employee.tax_file_number = "123123123"
#employee.title = "Mr"
#employee.start_date = Date.today - 30.days
#employee.mobile = "+6280123456"
#employee.phone = "+62801234560"
#employee.bank_accounts = [
#  XeroGateway::Payroll::BankAccount.new(
#    {
#      :statement_text => "Common2", 
#      :account_name => "My Name2", 
#      :bsb => "234128", 
#      :account_number => "09809548", 
#      :reminder => true, 
#      :amount => 1000
#    }
#  )
#]

employee.super_memberships = [
  XeroGateway::Payroll::SuperMembership.new(
    :super_fund_id => "AMP84079300379",
    :employee_number => "3214",
    :super_membership_id => ""
  )
]

#home_address = XeroGateway::Payroll::HomeAddress.new 
#home_address.address_line1 = "Kaka address_line1"
#home_address.postal_code = "1234"
#home_address.city = "Bandung"
#home_address.region = "ACT"
#employee.home_address = home_address

#employee_xml = Builder::XmlMarkup.new

#pp employee_employee.to_xml

#response_create = employee.create 
response = gateway.get_payroll_super_funds
pp response.inspect

