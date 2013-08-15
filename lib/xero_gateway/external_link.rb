module XeroGateway
  class ExternalLink
  
    unless defined? ATTRS
      ATTRS = {
        "LinkType" => :string,
        "Url"      => :string
      }
    end    
    
    attr_accessor *ATTRS.keys.map(&:underscore)
    
    def initialize(params = {})
      params.each do |k,v|
        self.send("#{k}=", v)
      end
    end
    
    def ==(other)
      ATTRS.keys.map(&:underscore).each do |field|
        return false if send(field) != other.send(field)
      end
      return true
    end
    
    def to_xml
      b = Builder::XmlMarkup.new
      
      b.ExternalLink do
        ATTRS.keys.each do |attr|
          eval("b.#{attr} '#{self.send(attr.underscore.to_sym)}'")
        end
      end
    end
    
    def self.from_xml(external_link_element)
      ExternalLink.new.tap do |el|
        external_link_element.children.each do |element|
        
          attribute             = element.name
          underscored_attribute = element.name.underscore
        
          if ATTRS.keys.include?(attribute)
                  
            case (ATTRS[attribute])
              when :boolean then  el.send("#{underscored_attribute}=", (element.text == "true"))
              when :float   then  el.send("#{underscored_attribute}=", element.text.to_f)
              else                el.send("#{underscored_attribute}=", element.text)
            end
            
          else
            
            warn "Ignoring unknown attribute: #{attribute}" 
            
          end
          
        end
      end
    end
  end
end
  
