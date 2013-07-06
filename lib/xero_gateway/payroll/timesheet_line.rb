module XeroGateway::Payroll
  class NoGatewayError < StandardError; end

  class TimesheetLine
    attr_accessor :gateway

    # Any errors that occurred when the #valid? method called.
    attr_reader :errors

    attr_accessor :earnings_rate_id, :number_of_units, :tracking_item_id

     def initialize(params = {})
      @errors ||= []

      params = {}.merge(params)
      params.each do |k,v|
        self.send("#{k}=", v)
      end
    end

    def 

    def to_xml(b = Builder::XmlMarkup.new)
      b.TimesheetLine {
        b.NumberOfUnits  self.number_of_units  if self.number_of_units
        b.EarningsRateID self.earnings_rate_id if self.earnings_rate_id
        b.TrackingItemID self.tracking_item_id if self.tracking_item_id
      }
    end 
    
    def self.from_xml(timesheet_line_element, gateway = nil)
      timesheet_line = TimesheetLine.new
      timesheet_line_element.children.each do |element|
        case(element.name)
          when "NumberOfUnits"  then timesheet_line.number_of_units  = element.text
          when "EarningsRateID" then timesheet_line.earnings_rate_id = element.text
          when "TrackingItemID" then timesheet_line.tracking_item_id = element.text
        end
      end 
      timesheet_line  
    end 
    
    def ==(other)
      [ :earnings_rate_id, :number_of_units, :tracking_item_id ].each do |field|
        return false if send(field) != other.send(field)
      end
      return true
    end
  end
end
