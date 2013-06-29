module XeroGateway::Payroll
  class LeaveApplication
    include XeroGateway::Dates
     
    # Xero::Gateway associated with this leave_period.
    attr_accessor :gateway

    # Any errors that occurred when the #valid? method called.
    attr_reader :errors
    
    attr_accessor :employee_id, :leave_type_id, :title, :start_date, :end_date, :description, :leave_periods
    
    def initialize(params = {})
      @errors ||= []

      params = {}.merge(params)
      params.each do |k,v|
        self.send("#{k}=", v)
      end
    end

    def to_xml(b = Builder::XmlMarkup.new)
      b.LeaveApplication {
      	b.EmployeeId self.employee_id if self.employee_id
      	b.LeaveTypeId self.leave_type_id if self.leave_type_id
      	b.Title self.title if self.title
      	b.StartDate self.class.format_date(self.start_date) if self.start_date
      	b.EndDate self.class.format_date(self.end_date) if self.start_date
        b.Description self.description if self.description
        b.LeavePeriods self.leave_periods if self.leave_periods     	
      }
    end 

    def self.from_xml(leave_application_element, gateway = nil)
      leave_application = LeaveApplication.new
      leave_application_element.child.each do |element|
      case(element.name)
        when "EmployeeId"   then leave_application.employee_id   = element.text
        when "LeaveTypeId"  then leave_application.leave_type_id = element.text
        when "Title"        then leave_application.title.        = element.text
        when "StartDate"    then leave_application.start_date    = parse_date(element.text)
        when "EndDate"      then leave_application.end_date      = parse_date(element.text)
        when "Description"  then leave_application.description   = element.text
        when "LeavePeriods" then element.children.each {|child| leave_application.leave_periods << LeavePeriod.from_xml(child, gateway) }
      end
      leave_application      
    end 

    def ==(other)
      [ :employee_id, :leave_type_id, :title, :start_date, :end_date, :description, :leave_periods ].each do |field|
        return false if send(field) != other.send(field)
      end
      return true
    end
  end
end

    
    















    def to_xml(b = Builder::XmlMarkup.new)
      b.LeavePeriod {
      	b.NumberOfUnits self.number_of_units if self.number_of_units
      	b.PayPeriodEndDate self.class.format_date(self.pay_period_end_date) if self.pay_period_end_date
      	b.PayPeriodStartDate self.class.format_date(self.pay_period_start_date) if self.pay_period_start_date
      	b.LeavePeriodStatus self.leave_period_status if self.leave_period_status
      }
    end 
    
    def self.from_xml(leave_period_element, gateway = nil)
      leave_period = LeavePeriod.new
      leave_period_element.child.each do |element|
      case(element.name)
        when "NumberOfUnits" then leave_period.number_of_units = element.text
        when "PayPeriodEndDate" then leave_period.pay_period_end_date = parse_date(element.text)
        when "PayPeriodStartDate" then leave_period.pay_period_start_date = parse_date(element.text)
        when "LeavePeriodStatus" then leave_period.leave_period_status = element.text
      end
      leave_period  
    end 
    
    def ==(other)
      [ :number_of_units, :pay_period_end_date, :pay_period_start_date, :leave_period_status].each do |field|
        return false if send(field) != other.send(field)
      end
      return true
    end
    end
  end
end