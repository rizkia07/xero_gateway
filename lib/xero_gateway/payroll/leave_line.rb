module XeroGateway::Payroll
  class LeaveLine
    include XeroGateway::Dates
     
    # Xero::Gateway associated with this leave_period.
    attr_accessor :gateway

    # Any errors that occurred when the #valid? method called.
    attr_reader :errors
    
    attr_accessor :leave_type_id, :number_of_units
    
    def initialize(params = {})
      @errors ||= []

      params = {}.merge(params)
      params.each do |k,v|
        self.send("#{k}=", v)
      end
    end
    
    def to_xml(b = Builder::XmlMarkup.new)
      b.LeaveLines {
      	b.LeaveTypeId self.leave_type_id if self.leave_type_id
      	b.NumberOfUnits self.number_of_units if self.number_of_units
      }
    end 

    def self.from_xml(leave_type_element, gateway = nil)
      leave_line = LeaveLine.new
      leave_line.child.each do |element|
      case(element.name)
        when "LeaveTypeId" then leave_lines.leave_type_id = element.text
        when "NumberOfUnits" then leave_lines.number_of_units = element.text
      end
      leave_line
    end 
    
    def ==(other)
      [ :leave_type_id, :number_of_units ].each do |field|
        return false if send(field) != other.send(field)
      end
      return true
    end
    end
  end
end