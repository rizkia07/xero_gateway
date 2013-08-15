require "cgi"
require "uri"
require "net/https"
require "rexml/document"
require "builder"
require "bigdecimal"
require "oauth"
require 'oauth/signature/rsa/sha1'
require "forwardable"
require "active_support/all"
require "tempfile"

require File.join(File.dirname(__FILE__), 'oauth', 'oauth_consumer')

require File.join(File.dirname(__FILE__), 'xero_gateway', 'http_encoding_helper')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'http')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'dates')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'money')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'line_item_calculations')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'response')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'account')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'accounts_list')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'tracking_category')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'contact')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'employee')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'line_item')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payment')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'invoice')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'bank_transaction')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'credit_note')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'journal_line')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'manual_journal')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'address')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'phone')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'organisation')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'tax_rate')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'currency')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'error')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'oauth')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'exceptions')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'gateway')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'private_app')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'partner_app')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','employee')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','home_address')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','bank_account')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','super_membership')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','pay_template')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','earnings_line')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','super_fund')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','tax_declaration')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','pay_item')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','earnings_rate')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','deduction_type')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','leave_type')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','reimbursement_type')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','leave_application')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','leave_period')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','deduction_line')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','leave_accrual_line')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','payslip')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','reimbursement_line')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','superannuation_line')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','tax_line')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','payroll_calendar')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'payroll','pay_run')
require File.join(File.dirname(__FILE__), 'xero_gateway', 'external_link')
