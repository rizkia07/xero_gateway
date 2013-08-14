module XeroGateway
  class Organisation
    
    unless defined? ATTRS
      ATTRS = {
        "Name" 	                => :string,     # Display name of organisation shown in Xero
        "LegalName"             => :string,	   # Organisation name shown on Reports
        "PaysTax" 	            => :boolean,    # Boolean to describe if organisation is registered with a local tax authority i.e. true, false
        "Version"   	          => :string,     # See Version Types
        "BaseCurrency"          => :string,     # Default currency for organisation. See Currency types
        "OrganisationType"      => :string,     # UNDOCUMENTED parameter, only returned for "real" (i.e non-demo) companies
        "OrganisationStatus"    => :string,   # UNDOCUMENTED parameter
        "IsDemoCompany"         => :boolean,    # UNDOCUMENTED parameter
        "APIKey"                => :string,     # UNDOCUMENTED paramater, returned if organisations are linked via Xero Network
        "CountryCode"           => :string,      # UNDOCUMENTED parameter
        "TaxNumber"             => :string,
        "FinancialYearEndDay"   => :string,
        "FinancialYearEndMonth" => :string,
        "PeriodLockDate"        => :string,
        "CreatedDateUTC"        => :string,
        "Addresses"             => :array,
        "EndOfYearLockDate"     => :string,
        "RegistrationNumber"    => :string,
        "ShortCode"             => :string,
        "Timezone"              => :string,
        "Phones"                => :array,
        "ExternalLinks"         => :array,
        "OrganisationEntityType"  => :string
      }
    end
    
    attr_accessor *ATTRS.keys.map(&:underscore)
    
    def initialize(params = {})
      params.each do |k,v|
        self.send("#{k}=", v)
      end
      
      @addresses ||= []
      @phones ||= []
      @external_links ||= []
    end
    
    def ==(other)
      ATTRS.keys.map(&:underscore).each do |field|
        return false if send(field) != other.send(field)
      end
      return true
    end
    
    def to_xml
      b = Builder::XmlMarkup.new
      
      b.Organisation do
        ATTRS.keys.each do |attr|
          ATTRS[attr] == :array ? (eval("b.#{attr}{self.attributes_contains_array_to_xml(attr, b)}")) : 
            eval("b.#{attr} '#{self.send(attr.underscore.to_sym)}'")
        end
      end
    end
    
    def self.from_xml(organisation_element)
      Organisation.new.tap do |org|
        organisation_element.children.each do |element|
        
          attribute             = element.name
          underscored_attribute = element.name.underscore
        
          if ATTRS.keys.include?(attribute)
                  
            case (ATTRS[attribute])
              when :boolean then  org.send("#{underscored_attribute}=", (element.text == "true"))
              when :float   then  org.send("#{underscored_attribute}=", element.text.to_f)
              when :array   then  org.attributes_contains_array_from_xml(attribute, element)
              else                org.send("#{underscored_attribute}=", element.text)
            end
            
          else
            
            warn "Ignoring unknown attribute: #{attribute}" 
            
          end
          
        end
      end
    end
    
    def attributes_contains_array_from_xml(name, element)
      case name
        when "Addresses" then element.children.each {|address_element| self.addresses << Address.from_xml(address_element)}
        when "Phones" then element.children.each {|phone_element| self.phones << Phone.from_xml(phone_element)}
        when "ExternalLinks" then element.children.each {|external_link_element| self.external_links << ExternalLink.from_xml(external_link_element)}        
        else warn "Ignoring unknown attribute: #{name}" 
      end 
    end 
    
    def attributes_contains_array_to_xml(name, xml_builder)
      case name
        when "Addresses" then addresses.each { |address| address.to_xml(xml_builder) }
        when "Phones" then phones.each { |phone| phone.to_xml(xml_builder) }
        when "ExternalLinks" then external_links.each { |external_link| external_link.to_xml(xml_builder) }
        else warn "Ignoring unknown attribute: #{name}" 
      end 
    end 
  end
end
