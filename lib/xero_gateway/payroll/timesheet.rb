module XeroGateway::Payroll
  class NoGatewayError < StandardError; end
  
  class Timesheet
    include XeroGateway::Dates
     
    TIMESHEET_STATUS = [
      "DRAFT", "PROCESSED"
    ]unless defined?(TIMESHEET_STATUS)
    
    attr_accessor :gateway

    # Any errors that occurred when the #valid? method called.
    attr_reader :errors
    
    attr_accessor :employee_id, :start_date, :end_date, :timesheet_lines, :status, :hours, :timesheet_id


    def initialize(params = {})
      @errors ||= []

      params = {}.merge(params)
      params.each do |k,v|
        self.send("#{k}=", v)
      end
      
      @timesheet_lines = []
    end

    def to_xml(b = Builder::XmlMarkup.new)
      b.Timesheet {
        b.EmployeeID self.employee_id if self.employee_id
        b.StartDate self.start_date.strftime("%Y-%m-%dT%H:%M:%S") if self.start_date
        b.EndDate self.end_date.strftime("%Y-%m-%dT%H:%M:%S") if self.start_date
        b.Status self.status if self.status
        b.Hours self.hours if self.hours
        b.TimesheetID self.timesheet_id if self.timesheet_id
        b.TimesheetLines{
          self.timesheet_lines.each do |timesheet_line|
            timesheet_line.to_xml(b)
          end 
        }unless self.timesheet_lines.blank?        
      }
    end 
    
    def self.from_xml(timesheet_element, gateway = nil)
      timesheet = Timesheet.new
      timesheet_element.children.each do |element|
        case(element.name)
          when "EmployeeID"     then timesheet.employee_id   = element.text
          when "StartDate"      then timesheet.start_date    = parse_date(element.text)
          when "EndDate"        then timesheet.end_date      = parse_date(element.text)
          when "Status"         then timesheet.status        = element.text
          when "Hours"          then timesheet.hours         = element.text
          when "TimesheetID"    then timesheet.timesheet_id  = element.text
          when "TimesheetLines" then element.children.each {|child| timesheet.timesheet_lines << TimesheetLine.from_xml(child, gateway) } 
        end
      end 
      timesheet      
    end 

    def ==(other)
      [ :employee_id, :start_date, :end_date, :timesheet_lines, :status, :hours, :timesheet_id ].each do |field|
        return false if send(field) != other.send(field)
      end
      return true
    end    
  end
end
