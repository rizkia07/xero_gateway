require File.dirname(__FILE__) + '/../test_helper'

class GetOrganisationTest < Test::Unit::TestCase
  include TestHelper
  
  def setup
    @gateway = XeroGateway::Gateway.new(CONSUMER_KEY, CONSUMER_SECRET)
    
    if STUB_XERO_CALLS
      @gateway.xero_url = "DUMMY_URL"
      
      @gateway.stubs(:http_get).with {|client, url, params| url =~ /Organisation$/ }.returns(get_file_as_string("organisation.xml"))          
    end
  end
  
  def test_get_organisation
    result = @gateway.get_organisation
    assert result.success?
    assert !result.response_xml.nil?
    
    assert_equal XeroGateway::Organisation, result.organisation.class
    assert_equal "Demo Company (NZ)", result.organisation.name
    assert_equal "Demo Company (NZ)", result.organisation.legal_name
    assert result.organisation.pays_tax
    assert_equal "NZ", result.organisation.version
    assert_equal "COMPANY", result.organisation.organisation_type
    assert_equal 2, result.organisation.addresses.length
    assert_equal 4, result.organisation.phones.length
    assert_equal 5, result.organisation.external_links.length
  end
end
